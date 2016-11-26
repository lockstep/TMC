class MailchimpSubscriberWorker
  include Sidekiq::Worker

  def perform(user_id, list = nil)
    user = User.find(user_id)
    MailchimpSubscriber.new.subscribe(user, list)
  end
end
