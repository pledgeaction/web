class UserCause < ActiveRecord::Base
  belongs_to :user
  belongs_to :cause

  # TOOD: add uniqueness validates_uniqueness_of :id, :scope => [:cause_id, :user_id]
end
