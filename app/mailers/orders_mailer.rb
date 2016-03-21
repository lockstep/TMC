class OrdersMailer < ApplicationMailer
  def confirmed_order(order_id)
    @order = Order.find(order_id)
    mail(to: @order.user.email, subject: "Confirmed Order##{@order.id}")
  end
end
