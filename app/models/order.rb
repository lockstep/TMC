class Order < ActiveRecord::Base
  belongs_to :user
  has_one :charge
  has_one :adjustment
  has_many :line_items
  has_many :products, through: :line_items

  enum state: [:active, :paid]

  delegate :promotion, to: :adjustment, allow_nil: true
  delegate :code, :description, to: :promotion, allow_nil: true, prefix: true
  delegate :amount, to: :adjustment, prefix: true, allow_nil: true

  def item_total
    line_items.inject(0) do |sum, line_item|
      sum + line_item.product.price
    end
  end

  def adjustment_total
    adjustment_amount.to_f
  end

  def retrieve_all_shipping_costs!(recipient)
    line_items.includes(:product)
      .where(products: { fulfill_via_shipment: true })
      .each do |line_item|
        shipping_cost = Shipper.get_lowest_cost(
          recipient, line_item.product
        )
        line_item.update(shipping_cost_cents: shipping_cost.price_cents)
    end
  end

  def shipping_total
    line_items.inject(0) do |sum, line_item|
      sum + line_item.shipping_cost_cents.to_i
    end / 100.0
  end

  def shipping_costs_calculated?
    line_items.all? do |line_item|
      !line_item.fulfill_via_shipment? || line_item.shipping_cost_cents.to_i > 0
    end
  end

  def total
    item_total - adjustment_total + shipping_total
  end
end
