class UsersMailer < ApplicationMailer
  def welcome_new_user(user_id, hide_products = false)
    @utm = "utm_source=TMC&utm_medium=welcome_new_user&" \
      "utm_campaign=transactional_emails"
    @user = User.find(user_id)
    @hide_products = hide_products
    @results = Product.search('*', order: { times_sold: :desc }).first(4)
    subject = @hide_products ? "Welcome to The Montessori Directory" : "Welcome to The Montessori Company"
    mail(to: @user.email, subject: subject)
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

  def new_breakout_session_comment(comment_id)
    @comment = FeedItems::Comment.find(comment_id)
    @breakout_session = @comment.feedable
    @recipients = @breakout_session.organizers.pluck(:email)
    @author = @comment.author
    mail(
      to: @recipients,
      bcc: ADMIN_EMAILS,
      reply_to: ADMIN_EMAILS,
      subject: "New Comment on #{@breakout_session.name}"
    )
  end

  def new_breakout_session_application(breakout_session_id)
    @breakout_session = BreakoutSession.find(breakout_session_id)
    mail(to: ADMIN_EMAILS, subject: "New Breakout Session Application")
  end

  def bad_link(product)
    @product = product
    mail(to: ADMIN_EMAILS, subject: "Bad Link Found on TMC")
  end
end
