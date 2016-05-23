class OrdersMailerPreview < ActionMailer::Preview
  def confirmed_order
    OrdersMailer.confirmed_order(Order.paid.last.id)
  end
end
