class OrdersMailerPreview < ActionMailer::Preview
  def confirmed_order_no_discount
    OrdersMailer.confirmed_order(Order.paid.last.id)
  end

  def confirmed_order_discount
    OrdersMailer.confirmed_order(Adjustment.last.order.id)
  end
end
