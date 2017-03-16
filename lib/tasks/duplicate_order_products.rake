namespace :duplicate_order_products do
  desc 'Notify admins duplicate order product items within last 24 hrs'
  task notify: :environment do
    duplicate_products_order_ids = []
    Order.includes(:line_items).where(created_at: 24.hours.ago..Time.now)
      .find_each do |order|
      next if order.line_items.group(:product_id).having('count(*) > 1').empty?
      duplicate_products_order_ids.push(order.id)
    end
    unless duplicate_products_order_ids.empty?
      OrdersMailer.notify_duplicate_products(duplicate_products_order_ids).deliver_now
    end
  end
end
