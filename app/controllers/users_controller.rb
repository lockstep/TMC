class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :prepare_user, only: :update

  def show
    redirect_to user_materials_path @user
  end

  def edit_address
  end

  def update
    if @user.update_attributes(user_params)
      Interest.update_user_interests(@user, @interests)
      Certification.update_user_certifications(@user, @certifications)
      sign_in(@user, bypass: true)
      if session[:calculating_shipping_for_product].present?
        redirect_to shipping_product_path(
          session[:calculating_shipping_for_product]
        )
      elsif session[:calculating_shipping_for_cart].present?
        redirect_to cart_path(calculate_shipping: true)
      elsif params['commit'].match 'Pilot'
        MailchimpSubscriberWorker.perform_async(@user.email, 'c94cda6346')
        redirect_to :back
      else
        flash[:notice] = 'Your account has been updated.'
        render update_complete_path(params['commit'])
      end
    else
      render update_complete_path(params['commit'])
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation, :address_line_one,
      :address_line_two, :address_city, :address_state, :address_postal_code,
      :address_country, :editing_address, :editing_profile,
      :first_name, :last_name, :position, :school_name,
      :bambini_pilot_participant, :bio, :avatar
    )
  end

  def update_complete_path(commit_params)
    if commit_params.match('address')
      'edit_address'
    elsif commit_params.match('profile')
      'profile'
    else
      'edit'
    end
  end

  def prepare_user
    @interests = params[:user].delete(:interests)
    @certifications = params[:user].delete(:certifications)
  end
end
