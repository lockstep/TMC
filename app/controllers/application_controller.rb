class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  force_ssl if: :ssl_configured?

  before_action :find_or_create_order

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      flash[:alert] = "Access to that page has been denied."
      redirect_to error_403_path
    else
      flash[:notice] = "Please log in to access that page."
      redirect_to new_user_session_path
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to '/', alert: 'Record does not exist.'
  end

  def after_sign_in_path_for(resource)
    session[:after_sign_in_path] || stored_location_for(resource) || root_path
  end

  def after_sign_out_path_for(resource)
    request.referrer
  end

  def ssl_configured?
    Rails.env.production?
  end

  def find_or_create_order
    if session[:order_id].present?
      session_order = Order.find_by_id(session[:order_id])

      unless session_order
        @order = Order.create(state: :active)
        session[:order_id] = @order.id
        return
      end

      @order = session_order.active? ?
        session_order : Order.create(state: :active)
    else
      @order = Order.create(state: :active)
    end
    session[:order_id] = @order.id
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, session)
  end
end
