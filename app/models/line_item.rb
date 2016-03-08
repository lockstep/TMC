class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :order

  validates_uniqueness_of :product_id, scope: :order_id
end
