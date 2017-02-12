class UserAction < ActiveRecord::Base
  belongs_to :user
  belongs_to :action

  # TOOD: add uniqueness validates_uniqueness_of :id, :scope => [:cause_id, :user_id]
end
