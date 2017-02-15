class OrganizedBreakoutSession < ActiveRecord::Base
  belongs_to :user
  belongs_to :breakout_session
end
