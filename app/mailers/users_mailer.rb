class UsersMailer < ApplicationMailer
  def welcome_new_user(user_id)
    @user = User.find(user_id)
    @results = Product.search('*', order: { times_sold: :desc }).take(4)
    mail(to: @user.email,
         subject: "#{I18n.t('emails.welcome')} #{I18n.t('site_name')}"
        )
  end
end
