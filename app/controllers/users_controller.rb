class UsersController < ApplicationController
  load_and_authorize_resource

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = 'Your preferences have been updated.'
      sign_in(@user, bypass: true)
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation,
                                :first_name)
  end
end
