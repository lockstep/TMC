class Charge < ActiveRecord::Base
  belongs_to :order
  has_many :line_items, through: :order
  has_many :products, through: :line_items

  after_commit :send_notifications, :reindex_products

  def self.monthly_sales(time: Time.now)
    Charge
      .where(created_at: time.beginning_of_month..time.end_of_month)
      .sum(:amount)
  end

  def self.total_sales
    Charge.sum(:amount)
  end

  private

  def send_notifications
    OrderConfirmationWorker.perform_async(order.id)
    NotifySlackWorker.perform_async(self.id) if ENV['ENABLE_TRACKING']
  end

  def reindex_products
    ReindexProductsWorker.perform_async(products.map(&:id))
  end
end
