class BreakoutSessionComment < ActiveRecord::Base
  belongs_to :breakout_session
  belongs_to :user

  validates_presence_of :message

end
