class Product < ActiveRecord::Base
  has_and_belongs_to_many :presentations
  has_one :sku
end
