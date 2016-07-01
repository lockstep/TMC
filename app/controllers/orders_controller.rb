class OrdersController < ApplicationController
  skip_before_action :find_or_create_order

  before_action :set_order, only: [:show, :success]
  after_action :set_after_sign_in_path, only: [:show]

  def show
    authorize! :show, @order
    if @order.paid?
      redirect_to user_order_path(current_user, @order)
    end
  end

  def success
    authorize! :show, @order
    redirect_to user_materials_path(current_user) unless session[:new_order]
    session.delete(:new_order)
  end

  private

  def set_order
    @order = Order.eager_load(line_items: [:product]).find(params[:id])
  end

  def set_after_sign_in_path
    session[:after_sign_in_path] = order_path(@order)
  end
end
