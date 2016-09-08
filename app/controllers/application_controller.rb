class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  force_ssl if: :ssl_configured?

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      flash[:alert] = "Access to that page has been denied."
      redirect_to error_403_path
    else
      flash[:notice] = "Please log in to access that page."
      redirect_to new_user_session_path
    end
  end

  def after_sign_in_path_for(resource)
    session[:after_sign_in_path] || stored_location_for(resource) || root_path
  end

  def after_sign_out_path_for(resource)
    root_url
  end

  def ssl_configured?
    Rails.env.production?
  end

  def set_current_order(options = {})
    options[:create_order_if_necessary] ||= false
    method = options[:create_order_if_necessary] ? :create : :new

    if session[:order_id].present?
      session_order = Order.find_by(id: session[:order_id])

      unless session_order
        @order = Order.send(method, state: :active)
        session[:order_id] = @order.id
        return
      end

      @order = session_order.active? ?
        session_order : Order.send(method, state: :active)
    else
      @order = Order.send(method, state: :active)
    end
    session[:order_id] = @order.id
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, session)
  end
end
