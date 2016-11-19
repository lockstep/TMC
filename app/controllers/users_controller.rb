class UsersController < ApplicationController
  load_and_authorize_resource

  def show
    redirect_to user_materials_path @user
  end

  def edit_address
  end

  def update
    if @user.update_attributes(user_params)
      sign_in(@user, bypass: true)
      if session[:calculating_shipping_for_product].present?
        redirect_to shipping_product_path(
          session[:calculating_shipping_for_product]
        )
      elsif session[:calculating_shipping_for_cart].present?
        redirect_to cart_path(calculate_shipping: true)
      else
        flash[:notice] = 'Your account has been updated.'
        render 'edit'
      end
    else
      render params['commit'].match('address') ? 'edit_address' : 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation, :address_line_one,
      :address_line_two, :address_city, :address_state, :address_postal_code,
      :address_country, :editing_address, :first_name, :last_name
    )
  end
end
