class ChargesController < ApplicationController
  before_action :set_order, only: [:new, :create]

  def show
  end

  def new
  end

  def create
    @amount = (@order.total_price*100).to_i

    stripe_processing

    @order.create_charge(email: params[:stripeEmail],
                         amount: @amount,
                         currency: 'usd',
                        )
    @order.state = 1
    @order.save
    redirect_to order_charge_path(order_id: @order.id, id: @order.charge.id)
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to @order
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def payment_params
    params.require(:payment).permit(:order_id)
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
    charge = Stripe::Charge.create(
      customer: @customer.id,
      amount: @amount,
      description: "payment for order##{@order.id}",
      currency: 'usd',
    )
  end
end
