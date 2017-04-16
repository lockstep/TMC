class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :prepare_user, only: :update

  def show
    redirect_to user_materials_path @user
  end

  def edit_profile
    authenticate_user!
    unless session[:alternate_onboarding_function].blank?
      if current_user.opted_in_to_public_directory?
        session.delete(:alternate_onboarding_function)
        if next_path = session[:post_directory_join_path]
          session.delete(:post_directory_join_path)
          redirect_to next_path
        else
          redirect_to directory_path, notice: t('users.already_in_directory')
        end
        return
      end
    end
  end

  def edit_address
  end

  def update
    @was_directory_member = @user.opted_in_to_public_directory?
    if @user.update_attributes(user_params)
      Interest.manage_user_interests(@user, @interests)
      Certification.manage_user_certifications(
        @user, @certifications
      )
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
        if opted_into_directory?
          flash[:notice] = t('devise.registrations.joined_directory')
          if next_path = session[:post_directory_join_path]
            session.delete(:post_directory_join_path)
            redirect_to next_path
          else
            redirect_to directory_path
          end
        else
          flash[:notice] = 'Your account has been updated.'
          render update_complete_path(params['commit'])
        end
      end
    else
      render update_complete_path(params['commit'])
    end
  end

  private

  def opted_into_directory?
    return if @was_directory_member
    @user.opted_in_to_public_directory?
  end

  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation, :address_line_one,
      :address_line_two, :address_city, :address_state, :address_postal_code,
      :address_country, :editing_address, :editing_profile,
      :first_name, :last_name, :position, :organization_name,
      :bambini_pilot_participant, :bio, :avatar, :opted_in_to_public_directory
    )
  end

  def update_complete_path(commit_params)
    if commit_params.match('address')
      'edit_address'
    elsif commit_params.match('profile')
      'edit_profile'
    else
      'edit'
    end
  end

  def prepare_user
    @interests = params[:user].delete(:interests)
    @certifications = params[:user].delete(:certifications)
  end
end
