class UsersMailer < ApplicationMailer
  def welcome_new_user(user_id)
    @utm = "utm_source=TMC&utm_medium=welcome_new_user&" \
      "utm_campaign=transactional_emails"
    @user = User.find(user_id)
    @results = Product.search('*', order: { times_sold: :desc }).first(4)
    mail(to: @user.email, subject: "Welcome to The Montessori Company")
  end
end
