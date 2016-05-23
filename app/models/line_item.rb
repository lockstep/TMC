class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :order
  delegate :name, :price, :download_url, to: :product

  validates_uniqueness_of :product_id, scope: :order_id
end
