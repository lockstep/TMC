module Orders::CartHelper
  def add_to_cart
    form_for [@order, LineItem.new] do |f|
      f.hidden_field(:product_id, value: @product.id).concat(
        f.submit('Add to Cart')
      )
    end
  end

  def checkout_btn
    form_for [@order, Charge.new] do |f|
      <<-BTN.html_safe
        <script src="https://checkout.stripe.com/checkout.js"
                class="stripe-button"
                data-key="#{Rails.configuration.stripe[:publishable_key]}"
                data-description="Payment for Order##{@order.id}"
                data-amount="#{@order.total_price*100}"
                data-locale="auto">
        </script>
      BTN
    end
  end
end
