class Charge < ActiveRecord::Base
  belongs_to :order

  after_create :send_notifications

  def send_notifications
    OrderConfirmationWorker.perform_async(order.id)
    NotifySlackWorker.perform_async(self.id) if ENV['ENABLE_TRACKING']
  end

  def self.monthly_sales(time: Time.now)
    Charge
      .where(created_at: time.beginning_of_month..time.end_of_month)
      .sum(:amount)
  end

  def self.total_sales
    Charge.sum(:amount)
  end
end
