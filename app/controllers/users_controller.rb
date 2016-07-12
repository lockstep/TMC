class UsersController < ApplicationController
  load_and_authorize_resource

  def update
    @user.skip_reconfirmation!
    if @user.update_attributes(user_params)
      flash[:notice] = 'Your preferences have been updated.'
      sign_in(@user, bypass: true)
    end
    render 'edit'
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
