class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:new]

  def new
  end

  def create
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def payment_params
    params.require(:payment).permit(:order_id)
  end
end
