describe MailchimpSubscriberWorker do
  fixtures :users

  before do
    Sidekiq::Testing.inline!
    @user = users(:paul)
    allow_any_instance_of(MailchimpSubscriber).to receive(:subscribe)
  end

  it 'calls the subscriber with the user instance' do
    expect_any_instance_of(MailchimpSubscriber).to receive(:subscribe)
      .with(@user)
    MailchimpSubscriberWorker.perform_async(@user.id)
  end
end
