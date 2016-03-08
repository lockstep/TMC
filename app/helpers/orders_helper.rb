module OrdersHelper
  def total_pricing
    <<-TOTAL.html_safe
      <a class='list-group-item disabled'>
        Total #{@order.total_price} USD
      </a>
    TOTAL
  end
end
