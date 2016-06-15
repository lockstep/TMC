class OrdersController < ApplicationController
  after_action :set_after_sign_in_path, only: [:show]
  before_action :set_order, only: [:show]

  def show
    authorize! :show, @order
    if @order.paid?
      redirect_to user_order_path(current_user, @order)
    end
  end

  private

  def set_order
    @order = Order.eager_load(line_items: [:product]).find(params[:id])
  end

  def set_after_sign_in_path
    session[:after_sign_in_path] = order_path(@order)
  end
end
