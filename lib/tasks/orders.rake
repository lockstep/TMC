namespace :orders do
  desc 'Remove orders with no line items'
  task remove_empty: :environment do
    Order.find_each do |order|
      next if order.line_items.size > 0
      order.destroy
    end
  end
end
