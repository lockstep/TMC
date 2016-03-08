class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  def show
    @order = Order.first_or_create(state: :active)
    @line_item = LineItem.new
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end
