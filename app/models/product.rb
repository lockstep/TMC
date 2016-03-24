class Product < ActiveRecord::Base
  include Imageable
  has_and_belongs_to_many :presentations
  has_one :downloadable
  delegate :download_url, to: :downloadable
end
