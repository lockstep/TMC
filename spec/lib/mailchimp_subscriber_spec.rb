describe MailchimpSubscriber do
  fixtures :users

  before do
    ENV['MAILCHIMP_LIST_ID'] = '1234'
  end

  describe '#subscribe' do
    before do
      @user = users(:paul)
    end
    it 'sends the right data' do
      expect_any_instance_of(Mailchimp::Lists).to(
        receive(:subscribe).with(
          '1234', { email: @user.email },
          nil, 'html', false, true, false
        )
      )
      MailchimpSubscriber.new.subscribe(@user.email)
    end
  end

  describe '#batch_subscribe' do
    before do
      @user_1 = users(:michelle)
      @user_2 = users(:paul)
    end
    it 'sends the right data' do
      batch = [@user_1, @user_2].map do |user|
        {
          email: { email: user.email },
          email_type: 'html',
          merge_vars: nil
        }
      end
      expect_any_instance_of(Mailchimp::Lists).to(
        receive(:batch_subscribe).with('1234', batch, false, true, false)
      )
      MailchimpSubscriber.new.batch_subscribe(
        User.find([@user_1.id, @user_2.id])
      )
    end
  end
end
