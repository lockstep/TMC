class UsersMailerPreview < ActionMailer::Preview
  def welcome_new_user
    UsersMailer.welcome_new_user(User.last)
  end

  def new_private_message
    UsersMailer.new_private_message(FeedItems::PrivateMessage.last)
  end
end
