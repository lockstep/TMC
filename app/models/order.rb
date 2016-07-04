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

  def total
    item_total - adjustment_total
  end
end
