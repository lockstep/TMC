class MailchimpSubscriberWorker
  include Sidekiq::Worker

  def perform(email, list = nil)
    MailchimpSubscriber.new.subscribe(email, list)
  end
end
