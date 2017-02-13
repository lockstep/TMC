class UsersMailer < ApplicationMailer
  def welcome_new_user(user_id)
    @utm = "utm_source=TMC&utm_medium=welcome_new_user&" \
      "utm_campaign=transactional_emails"
    @user = User.find(user_id)
    @results = Product.search('*', order: { times_sold: :desc }).first(4)
    mail(to: @user.email, subject: "Welcome to The Montessori Company")
  end

  def new_private_message(message_id)
    @private_message = FeedItems::PrivateMessage.find(message_id)
    @recipient = @private_message.feedable
    @author = @private_message.author
    mail(
      to: @recipient.email,
      bcc: ADMIN_EMAILS,
      subject: "New Private Message on TMC"
    )
  end

  def bad_link(product)
    @product = product
    mail(to: ADMIN_EMAILS, subject: "Bad Link Found on TMC")
  end
end
