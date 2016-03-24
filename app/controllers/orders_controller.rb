class OrdersController < ApplicationController
  after_action :set_after_sign_in_path, only: [:show]

  def show
    @order = Order.eager_load(line_items: [:product]).find(params[:id])
    authorize! :show, @order
  end

  private

  def set_after_sign_in_path
    session[:after_sign_in_path] = order_path(@order)
  end
end
