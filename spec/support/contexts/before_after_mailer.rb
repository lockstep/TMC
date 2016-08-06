shared_context "before_after_mailer" do
  before do
    Sidekiq::Testing.inline!
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end

  after do
    ActionMailer::Base.deliveries.clear
  end
end
