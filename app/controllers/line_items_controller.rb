class LineItemsController < ApplicationController
  def create
    set_current_order(create_order_if_necessary: true)
    @order.line_items.create(line_item_params)
    if !@order.user && current_user
      @order.update(user: current_user)
    end
    redirect_to @order
  end

  def destroy
    set_current_order
    @order.line_items.destroy(params[:id])
    redirect_to @order
  end

  private

  def line_item_params
    params.require(:line_item).permit(:product_id)
  end
end
