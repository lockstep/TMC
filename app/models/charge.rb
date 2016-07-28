class Charge < ActiveRecord::Base
  belongs_to :order

  after_create :send_order_confirmation

  def send_order_confirmation
    OrderConfirmationWorker.perform_async(order.id)
  end
end
