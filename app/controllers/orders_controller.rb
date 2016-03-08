class OrdersController < ApplicationController
  def show
    @order = Order.eager_load(line_items: [:product]).find(params[:id])
  end
end
