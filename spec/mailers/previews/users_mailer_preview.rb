class UsersMailerPreview < ActionMailer::Preview
  def welcome_new_user
    UsersMailer.welcome_new_user(User.last)
  end
end
