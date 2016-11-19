class CartsController < ApplicationController
  def my_cart
    set_current_order
    shipping_satisfied = calculate_shipping!
    render 'orders/show' if shipping_satisfied
  end

  private

  def calculate_shipping!
    return true unless params[:calculate_shipping] == 'true'
    if current_user.address_complete?
      session.delete(:calculating_shipping_for_cart)
      @order.retrieve_all_shipping_costs!(current_user)
      return true
    else
      session[:calculating_shipping_for_cart] = true
      redirect_to edit_address_user_path(current_user)
      return false
    end
  end

end
