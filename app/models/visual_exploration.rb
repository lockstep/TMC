class VisualExploration < ActiveRecord::Base
  include Imageable
  has_many :explorable_locations

  def image
    images.first
  end
end
