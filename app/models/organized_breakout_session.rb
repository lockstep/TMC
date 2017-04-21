class OrganizedBreakoutSession < ActiveRecord::Base
  belongs_to :user
  belongs_to :breakout_session

  delegate :full_name, to: :user, prefix: true
end
