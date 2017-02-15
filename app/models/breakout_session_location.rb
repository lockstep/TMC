class BreakoutSessionLocation < ActiveRecord::Base
  belongs_to :conference
  has_one :breakout_session
end
