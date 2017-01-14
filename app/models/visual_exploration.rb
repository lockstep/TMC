class VisualExploration < ActiveRecord::Base
  include Imageable
  has_many :explorable_locations
end
