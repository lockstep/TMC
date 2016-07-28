class WelcomeNewUserWorker
  include Sidekiq::Worker

  def perform(user_id)
    UsersMailer.welcome_new_user(user_id).deliver_now
  end
end
