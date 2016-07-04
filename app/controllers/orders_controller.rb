class OrdersController < ApplicationController
  skip_before_action :find_or_create_order

  before_action :set_order, only: [:show, :success, :update]
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

  def update
    authorize! :show, @order
    promotion = Promotion.find_by(code: params[:code].to_s.downcase)
    save_or_update_adjustment(promotion)
    redirect_to order_path @order
  end

  private

  def set_order
    @order = Order.eager_load(line_items: [:product]).find(params[:id])
  end

  def set_after_sign_in_path
    session[:after_sign_in_path] = order_path(@order)
  end

  def save_or_update_adjustment(promotion)
    return flash[:alert] = 'Promotion does not exist' unless promotion
    return flash[:alert] = 'Promotion is not active' if
      promotion.inactive?
    if promotion == @order.promotion
      flash[:notice] = 'The promotion has already been applied to this order.'
    elsif @order.promotion && @order.promotion != promotion
      @order.adjustment.update(promotion: promotion,
                               amount: promotion_amount(@order, promotion))
      flash[:notice] = 'Promotion has been applied'
    else
      @order.create_adjustment(promotion: promotion,
                               amount: promotion_amount(@order, promotion))
      flash[:notice] = 'Promotion has been applied'
    end
  end

  def promotion_amount(order, promotion)
    order.item_total * promotion.percent/100
  end
end
