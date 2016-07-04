class LineItem < ActiveRecord::Base
  after_create :update_order_adjustment
  after_destroy :update_order_adjustment

  belongs_to :product
  belongs_to :order
  delegate :name, :price, :download_url, :topic_name, to: :product

  validates_uniqueness_of :product_id, scope: :order_id

  def update_order_adjustment
    return unless order.adjustment
    amount = order.item_total * order.promotion.percent/100
    order.adjustment.update(amount: amount)
  end
end
