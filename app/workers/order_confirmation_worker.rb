class OrderConfirmationWorker
  include Sidekiq::Worker

  def perform(order_id)
    OrdersMailer.confirmed_order(order_id).deliver_now
  end
end
