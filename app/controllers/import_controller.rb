class ImportController < ApplicationController

  EMAIL_REGEX = /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  TWITTER_REGEX = /(?<=^|(?<=[^a-zA-Z0-9-_\.]))@([A-Za-z]+[A-Za-z0-9]+)/

  skip_before_action :verify_authenticity_token
  def typeform
    puts params
    puts params.to_json

    @user = User.new
    @user.signup_blob = params.to_json
    @user.save!

    if !params["form_response"] || !params["form_response"]["answers"]
      head :bad_request
      return
    end

    params["form_response"]["answers"].each do |answer|
      case answer["field"]["id"]
      when "42429695" #What causes are you interested in?
        answer["choices"]["labels"].each do |cause_name|
          cause = Cause.find_by_name(cause_name)
          if cause.blank?
            cause = Cause.create(:name => cause_name)
          end
          @user.causes << cause
        end
      when "42430551"
        #Your email
        @user.email = answer["email"]
      when "42428682"
        #how many hours per week will you pledge towards taking effective political?
        @user.hours_pledged = answer["number"]
      when "42437071"
        #Is it cool if we occasionally check in on whether or not you are making good on your pledge over text?
        @user.enable_text_checkins = answer["boolean"] 
      when "42432170"
        #Is it cool if we get some conversations started for you
        @user.enable_start_conversations = answer["boolean"] 
      when "42428811"
        #What's your name?
        @user.name = answer["text"]
      when "42428262"
        #How many hours did you spend last week on politics?
        hours = 0
        case answer["text"]
        when "a"
          hours = 2
        when "b"# 5-10
          hours = 7
        when "c" #10-20
          hours = 15
        when "d" #20-40
          hours = 30
        when "e" #40+
          hours = 40
        end
        @user.hours_spent_last_week = hours
      when "42430882"
        #Who else would you want to work closely with
        peers = answer["text"]
        peers.gsub(/\s+/, ' ').split(" ").each do |peer| # split on all whitespace
          if EMAIL_REGEX.match(peer)
            Peer.create(:from_user_id => @user.id, :to => peer, :kind => 'email')
          elsif TWITTER_REGEX.match(peer)
            Peer.create(:from_user_id => @user.id, :to => peer, :kind => 'twitter')
          end
        end
      when "42437020"
        #Your twitter handle
        @user.twitter_handle = answer["text"]
      when "42430824"
        #Who would you take direction from on what actions are effective
        follows = answer["text"]
        follows.gsub(/\s+/, ' ').split(" ").each do |follow| # split on all whitespace
          if EMAIL_REGEX.match(follow)
            Follow.create(:from_user_id => @user.id, :to => follow, :kind => 'email')
          elsif TWITTER_REGEX.match(follow)
            Follow.create(:from_user_id => @user.id, :to => follow, :kind => 'twitter')
          end
        end
      when "42436932"
        #What are your skillz?
        answer["choices"]["labels"].each do |skill_name|
          skill = Skill.find_by_name(skill_name)
          if skill.blank?
            skill = Skill.create(:name => skill_name)
          end
          @user.skills << skill
        end
      when "42429683"
        #What cause are you most excited to help with?
        cause_name = answer["choice"]["label"]
        if !@user.causes.find_by_name(cause_name)
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
      when "42437130"
        @user.phone_number = answer["text"]
      when "42437164"
        @user.zipcode = answer["text"]
      when "42480555"
        #What political actions have you taken in the last 12 months?
        answer["choices"]["labels"].each do |action_name|
          action = Action.find_by_name(action_name)
          if action.blank?
            action = Action.create(:name => action_name)
          end
          @user.actions << action
        end
      when "42437044"
        #Your primary online resume
        @user.resume_link = answer["text"]
      else
      end
    end

    @user.save!

    head :ok
  end

end
