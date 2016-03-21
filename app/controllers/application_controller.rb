class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to root_url
  end

  def after_sign_in_path_for(resource)
    session[:after_sign_in_path] || root_path
  end

  def after_sign_out_path_for(resource)
    request.referrer
  end
end
