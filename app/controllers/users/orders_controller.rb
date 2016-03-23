class Users::OrdersController < ApplicationController
  before_action :set_order, only: [:show]
  before_action :set_user, only: [:show, :index]

  def index
    @orders = @user.orders.paids
    authorize! :show, @user
  end

  def show
    authorize! :show, (@user || @order)
  end

  private

  def set_order
    @order = Order.includes(line_items: :product)
                  .find_by(id: params[:id], user_id: params[:user_id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
