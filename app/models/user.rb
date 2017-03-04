class User < ActiveRecord::Base
  has_many :user_causes
  has_many :causes, :through => :user_causes

  has_many :user_skills
  has_many :skills, :through => :user_skills

  has_many :user_actions
  has_many :actions, :through => :user_actions

  has_many :follows, :foreign_key => "from_user_id"
  has_many :peers, :foreign_key => "from_user_id"

  belongs_to :referrer, class_name: "User", foreign_key: "referring_user_id"
  has_many :referrals, class_name: "User", foreign_key: "referring_user_id"

  # get 8 random hex characters for an obfuscated user URL
  def url_hash
    "#{id}#{Random.rand}".hash.abs.to_s(16)[0..7]
  end

  before_create :save_url
  def save_url
    self.url = url_hash
  end

  def referred_pledge_hours
    referrals.map(&:hours_pledged).compact.reduce(:+) || 0
  end

  def primary_cause
   UserCause.where(:user_id => id, :primary => true).first.try(:cause)
  end

  def hours_acted
    Checkin.where(:phone_number => phone_number).map {|checkin| checkin.hours.to_i}.reduce(0, :+)
  end

  def pledge_material
    relevant_skill_ids = [1,2,3,4,6,7,12,14]
    relevant_overlap = relevant_skill_ids & skills.map(&:id)
    if relevant_overlap.length > 0
      true
    else
      false
    end
  end
end
