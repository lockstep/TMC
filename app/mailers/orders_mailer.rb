class OrdersMailer < ApplicationMailer
  def confirmed_order(order_id)
    @order = Order.eager_load(line_items: [:product]).find(order_id)
    @line_items = @order.line_items
    mail(to: @order.user.email, subject: "Your order is ready!")
  end

  def notify_vendor(line_item_id)
    line_item = LineItem.find(line_item_id)
    @line_items = [ line_item ]
    @buyer = line_item.user
    @vendor = line_item.vendor
    mail(
      to: @vendor.email, cc: ADMIN_EMAILS,
      subject: "New Purchase on The Marketplace"
    )
  end

  def notify_duplicate_products(order_ids)
    @orders = Order.where(id: order_ids)
    mail(
      to: ADMIN_EMAILS,
      subject: "Order with Duplicate Product Items"
    )
  end

end
