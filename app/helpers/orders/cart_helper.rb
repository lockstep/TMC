module Orders::CartHelper
  def add_to_cart
    form_for [@order, @line_item] do |f|
      f.hidden_field(:product_id, value: @product.id).concat(
        f.hidden_field(:order_id, value: @order.id)
      ).concat(
        f.submit('Add to cart')
      )
    end
  end

  def checkout_btn
    <<-BTN.html_safe
      <a href='/payments/new' class='btn btn-info'>Checkout</a>
    BTN
  end
end
