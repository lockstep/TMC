class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  def index
    @results = Product.all.order("RANDOM()")
    @recent_products = @results.limit(4)
  end

  def show
    if session[:order_id].present?
      @order = Order.find(session[:order_id]).active? ?
        Order.find(session[:order_id]) : Order.create(state: :active)
    else
      @order = Order.create(state: :active)
    end
    session[:order_id] = @order.id
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end
