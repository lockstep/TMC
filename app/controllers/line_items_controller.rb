class LineItemsController < ApplicationController
  before_action :set_order, only: [:create, :destroy]

  def create
    @order.line_items.create(line_item_params)
    if !@order.user && current_user
      @order.update(user: current_user)
    end
    redirect_to @order
  end

  def destroy
    @order.line_items.destroy(params[:id])
    redirect_to @order
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def line_item_params
    params.require(:line_item).permit(:product_id)
  end
end
