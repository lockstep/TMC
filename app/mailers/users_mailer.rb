class UsersMailer < ApplicationMailer
  def welcome_new_user(user_id)
    @utm = "utm_source=TMC&utm_medium=welcome_new_user&" \
      "utm_campaign=transactional_emails"
    @user = User.find(user_id)
    @results = Product.search('*', order: { times_sold: :desc }).take(4)
    mail(to: @user.email,
         subject: "#{I18n.t('emails.welcome')} #{I18n.t('site_name')}"
        )
  end
end
