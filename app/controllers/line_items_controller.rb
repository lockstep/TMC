class LineItemsController < ApplicationController
  def create
    @order = Order.find(params[:order_id])
    line_item = LineItem.where(line_item_params).first_or_create
    line_item.update_attributes(quantity: line_item.quantity + 1)
    redirect_to @order
  end

  private

  def line_item_params
    params.require(:line_item).permit(:product_id, :order_id)
  end
end
