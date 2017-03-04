require 'test_helper'

class ImportControllerTest < ActionController::TestCase
  test "should 400 if the submitted params aren't as expected" do
    response = post :typeform, { not_form_response: 'value' }
    assert response.code == '400'

    response = post :typeform, { form_response: { not_answers: 'value' } }
    assert response.code == '400'
  end

  test "should 200 and create a user if params are as expected" do
    response = post :typeform, { form_response: { answers: [] } }
    assert response.code == '200'
    assert User.count == 1
  end

  test "should save any causes given" do
    params_to_submit = {
      form_response: {
        answers: [
          {
            field: { id: ImportController::TypeFormQuestion.what_causes_would_you_consider_working_on },
            choices: { labels: ['label1', 'label2'], other: 'freeform' },
          },
        ]
      }
    }
    post :typeform, params_to_submit
    assert Cause.count == 3
  end

  test "should save email, hours, name, handle, ZIP, URL, and company if given" do
    params_to_submit = {
      form_response: {
        answers: [
          {
            field: { id: ImportController::TypeFormQuestion.your_email },
            email: 'user_email',
          },
          {
            field: { id: ImportController::TypeFormQuestion.how_many_hours_per_week },
            number: 2.5,
          },
          {
            field: { id: ImportController::TypeFormQuestion.whats_your_name },
            text: 'user_name',
          },
          {
            field: { id: ImportController::TypeFormQuestion.your_twitter_handle },
            text: 'user_handle',
          },
          {
            field: { id: ImportController::TypeFormQuestion.your_zipcode },
            number: '02139',
          },
          {
            field: { id: ImportController::TypeFormQuestion.your_primary_online_resume },
            url: 'user_url',
          },
          {
            field: { id: ImportController::TypeFormQuestion.where_do_you_work },
            text: 'user_company',
          },
        ],
      },
    }
    welcome_mail_stub = stub(deliver_now: true)
    WelcomeNotifier.expects(:send_welcome_email).returns(welcome_mail_stub)
    post :typeform, params_to_submit
    user = User.last
    assert user.email == 'user_email'
    assert user.hours_pledged == 2.5
    assert user.name == 'user_name'
    assert user.twitter_handle == 'user_handle'
    assert user.zipcode == '02139'
    assert user.resume_link == 'user_url'
    assert user.company == 'user_company'
  end

  test "should save hours last week if given" do
    params_to_submit = {
      form_response: {
        answers: [
          {
            field: { id: ImportController::TypeFormQuestion.how_many_hours_did_you_spend_last_week },
            choice: { label: '20-40' },
          },
        ],
      },
    }
    post :typeform, params_to_submit
    user = User.last
    assert user.hours_spent_last_week == 30
  end

  test "should save peers if given" do
    params_to_submit = {
      form_response: {
        answers: [
          {
            field: { id: ImportController::TypeFormQuestion.friends_emails },
            text: "t@f.com  @abc d@m.com not_valid",
          },
        ],
      },
    }
    peer_notifier_stub = stub(deliver_now: true)
    PeerNotifier.expects(:send_email_to_peers).returns(peer_notifier_stub)
    post :typeform, params_to_submit
    assert Peer.count == 3
    assert Set.new(Peer.all.map(&:to)) == Set.new(%w( t@f.com @abc d@m.com ))
  end

  test "should save skills if given" do
    params_to_submit = {
      form_response: {
        answers: [
          {
            field: { id: ImportController::TypeFormQuestion.what_are_your_skillz },
            choices: { labels: ['foo', 'bar'], other: 'baz' },
          },
        ],
      },
    }
    post :typeform, params_to_submit
    user = User.last
    assert user.skills.count == 3
    assert Set.new(Skill.all.map(&:name)) == Set.new(%w( foo bar baz ))
  end

  test "should save the cause the user is most excited to work on if given" do
    params_to_submit = {
      form_response: {
        answers: [
          {
            field: { id: ImportController::TypeFormQuestion.what_cause_would_you_be_the_most_excited_to_work_on },
            choice: { label: 'qux' },
          },
        ],
      },
    }
    post :typeform, params_to_submit
    cause = Cause.last
    user_cause = UserCause.last
    assert cause.name == 'qux'
    assert user_cause.primary
  end

  test "should normalize and save the user's phone number if given" do
    {
      '(415) 987-5432' => '+14159875432',
      '+44 800 238 3267' => '+448002383267',
    }.each do |raw_phone_number, normalized_phone_number|
      params_to_submit = {
        form_response: {
          answers: [
            {
              field: { id: ImportController::TypeFormQuestion.your_phone_number },
              text: raw_phone_number,
            },
          ],
        },
      }
      post :typeform, params_to_submit
      user = User.last
      assert user.phone_number == normalized_phone_number
      assert user.enable_text_checkins
    end
  end

  test "should save political actions if given" do
    params_to_submit = {
      form_response: {
        answers: [
          {
            field: { id: ImportController::TypeFormQuestion.what_political_actions_have_you_taken },
            choices: { labels: ['foo', 'bar'], other: 'baz' },
          },
        ],
      },
    }
    post :typeform, params_to_submit
    user = User.last
    assert user.actions.count == 3
    assert Set.new(Action.all.map(&:name)) == Set.new(%w( foo bar baz ))
  end

  test "should save political group if given" do
    params_to_submit = {
      form_response: {
        answers: [
          {
            field: { id: ImportController::TypeFormQuestion.what_political_group_do_you_most_identify_with },
            choice: { label: 'quux' },
          },
        ],
      },
    }
    post :typeform, params_to_submit
    user = User.last
    assert user.party_identification == 'quux'
  end

  test "should gracefully ignore an unrecognized answer ID" do
    params_to_submit = {
      form_response: { answers: [ { field: { id: 'unknown_id' } } ] }
    }
    post :typeform, params_to_submit
    assert response.code == '200'
    assert User.count == 1
  end

  test "should save the raw submitted params" do
    params_to_submit = {
      form_response: { answers: [ { field: { id: 'id', text: 'foo' } } ] }
    }
    post :typeform, params_to_submit
    user = User.last
    parsed_blob = JSON.parse(user.signup_blob, symbolize_names: true)
    assert parsed_blob[:form_response][:answers].first[:field][:text] == 'foo'
  end
end
