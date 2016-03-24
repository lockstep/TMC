class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :order
  delegate :download_url, to: :product
  delegate :name, to: :product

  validates_uniqueness_of :product_id, scope: :order_id
end
