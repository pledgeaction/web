class User < ActiveRecord::Base
  has_many :user_causes
  has_many :causes, :through => :user_causes

  has_many :user_skills
  has_many :skills, :through => :user_skills

  has_many :user_actions
  has_many :actions, :through => :user_actions

  has_many :follows, :foreign_key => "from_user_id"
  has_many :peers, :foreign_key => "from_user_id"
end
