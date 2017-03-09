class WelcomeNewUserWorker
  include Sidekiq::Worker

  def perform(user_id, hide_products = false)
    UsersMailer.welcome_new_user(user_id, hide_products).deliver_now
  end
end
