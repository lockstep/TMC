class Users::OrdersController < ApplicationController
  before_action :set_order, only: [:show]
  before_action :set_user, only: [:show, :index]
  before_action :authorize_order, only: [:show]

  def index
    authorize! :show, @user
    @orders = @user.orders.paids
  end

  def show
  end

  private

  def authorize_order
    authorize! :show, (@user && @order)
  end

  def set_order
    @order = Order.includes(line_items: :product)
                  .find_by(id: params[:id], user_id: params[:user_id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
