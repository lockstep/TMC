class ExplorableLocation < ActiveRecord::Base
  belongs_to :explorable, polymorphic: true
  belongs_to :visual_exploration
  validates_presence_of :x, :y, :label
end
