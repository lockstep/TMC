class UsersMailer < ApplicationMailer
  def welcome_new_user(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: 'Welcome to TMC')
  end
end
