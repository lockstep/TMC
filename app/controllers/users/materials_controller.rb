class Users::MaterialsController < ApplicationController
  before_action :set_user, only: [:index]

  def index
    store_location_for(:user, user_materials_url(@user))
    authorize! :show, @user
    @products = @user.purchased_products.with_downloadables
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
