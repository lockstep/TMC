class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      redirect_to error_403_path
    else
      redirect_to new_user_session_path
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to error_404_path
  end

  def after_sign_in_path_for(resource)
    session[:after_sign_in_path] || stored_location_for(resource) || root_path
  end

  def after_sign_out_path_for(resource)
    request.referrer
  end
end
