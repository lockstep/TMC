class CartsController < ApplicationController
  def my_cart
    set_current_order
    render 'orders/show'
  end
end
