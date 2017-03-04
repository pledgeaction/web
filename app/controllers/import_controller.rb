class ImportController < ApplicationController
  module TypeFormQuestion
    # The readable question mapping doesn't need to exactly match the question
    # text as it's displayed to the user or anything -- it's more so that
    # the mapping codes are more usable when developing.
    # For the current exact question wording see:
    # https://dannyhernandez.typeform.com/to/rY4sOO
    TYPEFORM_QUESTION_ROUGH_MAPPING = {
      '42429695' => 'What causes would you consider working on?',
      '42430551' => "Your email",
      '42428682' => "How many hours per week",
      '42428811' => "What's your name?",
      '42428262' => "How many hours did you spend last week",
      '42430882' => "Friends' emails",
      '42437020' => "Your twitter handle",
      '42430824' => "People you'd want advice from",
      '42436932' => "What are your skillz?",
      '42429683' => "What cause would you be the most excited to work on?",
      '42437130' => "Your phone number",
      '42437164' => "Your zipcode",
      '42480555' => "What political actions have you taken",
      '42437044' => "Your primary online resume",
      '42819760' => "Where do you work?",
      '44196824' => "What political group do you most identify with?",
    }
    TYPEFORM_QUESTION_ROUGH_MAPPING.each do |typeform_id, readable_question|
      methodable_question =
        readable_question.gsub(/\s/,'_').gsub(/[^A-Za-z_]/,'').downcase
      define_singleton_method(methodable_question) { typeform_id }
    end
  end

  EMAIL_REGEX = /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  TWITTER_REGEX = /(?<=^|(?<=[^a-zA-Z0-9\-_\.]))@([A-Za-z]+[A-Za-z0-9]+)/

  skip_before_action :verify_authenticity_token
  def typeform

    if !params["form_response"] || !params["form_response"]["answers"]
      head :bad_request
      return
    end

    @user = User.new
    @user.signup_blob = params.to_json
    @user.save!

    start_conversations = false
    params["form_response"]["answers"].each do |answer|
      case answer["field"]["id"]
      when TypeFormQuestion.what_causes_would_you_consider_working_on
        cause_names = [answer["choices"]["labels"], answer["choices"]["other"]].compact.flatten
        cause_names.each do |cause_name|
          cause = Cause.find_by_name(cause_name)
          if cause.blank?
            cause = Cause.create(:name => cause_name)
          end
          @user.causes << cause
        end
      when TypeFormQuestion.your_email
        @user.email = answer["email"]
      when TypeFormQuestion.how_many_hours_per_week
        @user.hours_pledged = answer["number"]
      when TypeFormQuestion.whats_your_name
        @user.name = answer["text"]
      when TypeFormQuestion.how_many_hours_did_you_spend_last_week
        hours = 0
        case answer["choice"]["label"]
        when "0-5"
            hours = 2
        when "5-10"
            hours = 7
        when "10-20"
            hours = 15
        when "20-40"
            hours = 30
        when "40+"
            hours = 40
        end
        @user.hours_spent_last_week = hours
      when TypeFormQuestion.friends_emails
        peers = answer["text"]
        peers.split(/\s+/).each do |peer| # split on all whitespace
          if EMAIL_REGEX.match(peer)
            Peer.create(:from_user_id => @user.id, :to => peer, :kind => 'email')
            start_conversations = true
          elsif TWITTER_REGEX.match(peer)
            Peer.create(:from_user_id => @user.id, :to => peer, :kind => 'twitter')
            start_conversations = true
          end
        end
      when TypeFormQuestion.your_twitter_handle
        @user.twitter_handle = answer["text"]
      when TypeFormQuestion.people_youd_want_advice_from
        follows = answer["text"]
        follows.gsub(/\s+/, ' ').split(" ").each do |follow| # split on all whitespace
          if EMAIL_REGEX.match(follow)
            Follow.create(:from_user_id => @user.id, :to => follow, :kind => 'email')
            start_conversations = true
          elsif TWITTER_REGEX.match(follow)
            Follow.create(:from_user_id => @user.id, :to => follow, :kind => 'twitter')
            start_conversations = true
          end
        end
      when TypeFormQuestion.what_are_your_skillz
        skill_names = [answer["choices"]["labels"], answer["choices"]["other"]].compact.flatten
        skill_names.each do |skill_name|
          skill = Skill.find_by_name(skill_name)
          if skill.blank?
            skill = Skill.create(:name => skill_name)
          end
          @user.skills << skill
        end
      when TypeFormQuestion.what_cause_would_you_be_the_most_excited_to_work_on
        cause_name = answer["choice"]["label"]
        unless @user.causes.find_by_name(cause_name)
          cause = Cause.find_by_name(cause_name)
          if cause.blank?
            cause = Cause.create(:name => cause_name)
          end
          @user.causes << cause
          @user.save
        end
        join = UserCause.find_by_user_and_name(@user, cause_name)
        join.primary = true
        join.save
      when TypeFormQuestion.your_phone_number
        phone_number = answer["text"].gsub(/\D/, '')
        if phone_number.length <= 10
          phone_number = "+1" + phone_number
        elsif phone_number[0] != "+"
          phone_number = "+" + phone_number
        end
        @user.phone_number = phone_number
        @user.enable_text_checkins = true
      when TypeFormQuestion.your_zipcode
        @user.zipcode = answer["number"]
      when TypeFormQuestion.what_political_actions_have_you_taken
        action_names = [answer["choices"]["labels"], answer["choices"]["other"]].compact.flatten
        action_names.each do |action_name|
          action = Action.find_by_name(action_name)
          if action.blank?
            action = Action.create(:name => action_name)
          end
          @user.actions << action
        end
      when TypeFormQuestion.your_primary_online_resume
        @user.resume_link = answer["url"]
      when TypeFormQuestion.where_do_you_work
        @user.company = answer["text"]
      when TypeFormQuestion.what_political_group_do_you_most_identify_with
        @user.party_identification = answer["choice"]["label"]
      else
        logger.warn "Unexpected TypeForm question ID: #{answer}"
      end
    end

    if params["form_response"]["hidden"] && params["form_response"]["hidden"]["ref_user"]
      @user.referrer = User.find_by_url(params["form_response"]["hidden"]["ref_user"])
    end

    @user.enable_start_conversations = start_conversations
    @user.save!

    WelcomeNotifier.send_welcome_email(@user).deliver_now

    if @user.peers.length > 0 && @user[:enable_start_conversations]
      PeerNotifier.send_email_to_peers(@user).deliver_now
    end

    if @user.follows.length > 0 && @user[:enable_start_conversations]
      FollowNotifier.send_email_to_follows(@user).deliver_now
    end

    head :ok
  end

end
