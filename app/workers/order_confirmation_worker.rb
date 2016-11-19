class OrderConfirmationWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)
    OrdersMailer.confirmed_order(order.id).deliver_now
    order.line_items.joins(:product)
      .where(products: { fulfill_via_shipment: true }).each do |line_item|
      OrdersMailer.notify_vendor(line_item.id).deliver_now
    end
  end
end
