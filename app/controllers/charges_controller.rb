class ChargesController < ApplicationController
  before_action :set_order, only: [:create]

  def create
    @order.update(user: current_user) unless @order.user
    @amount = (@order.total_price*100).to_i

    stripe_processing

    @order.create_charge(email: params[:stripeEmail],
                         amount: @amount,
                         currency: 'usd',
                        )
    @order.update(state: :paid)
    redirect_to success_order_path(@order)
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to @order
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def stripe_processing
    create_stripe_customer
    create_stripe_charge
  end

  def create_stripe_customer
    @customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      source: params[:stripeToken],
    )
  end

  def create_stripe_charge
    Stripe::Charge.create(
      customer: @customer.id,
      amount: @amount,
      description: "payment for Order ##{@order.id}",
      currency: 'usd',
    )
  end
end
