class UserCause < ActiveRecord::Base
  belongs_to :user
  belongs_to :cause

  # TOOD: add uniqueness validates_uniqueness_of :id, :scope => [:cause_id, :user_id]

  def self.find_by_user_and_name(user, name)
    cause = Cause.find_by_name(name)
    return nil unless cause
    UserCause.where(:user_id => user.id, :cause_id => cause.id).first
  end
end
