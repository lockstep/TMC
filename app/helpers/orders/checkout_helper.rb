module Orders::CheckoutHelper
  def checkout_actions
    current_user ? checkout_btn : authenticate_btn
  end

  private

  def authenticate_btn
    link_to 'Log in', new_user_session_path
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
