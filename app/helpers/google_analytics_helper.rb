module GoogleAnalyticsHelper
  def get_transaction_js(order)
    <<-JS
      ga('ecommerce:addTransaction', {
        'id': '#{order.id}',
        'affiliation': 'The Montessori Company',
        'revenue': '#{order.total_price}'
      });
    JS
  end

  def get_items_js(order)
    order.line_items.map { |item| get_item_js(order, item) }.join
  end

  def get_item_js(order, item)
    <<-JS
      ga('ecommerce:addItem', {
        'id': '#{order.id}',
        'name': '#{item.name}',
        'sku': '#{item.product_id}',
        'category': '#{item.topic_name}',
        'price': '#{item.price}',
        'quantity': '1'
      });
    JS
  end
end
