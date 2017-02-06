describe GuestsController, type: :controller do
  fixtures :users

  include_context 'before_after_mailer'

  before do
    @user = users(:michelle)
  end

  describe '#join_newsletter' do
    it 'joins the newsletter' do
      request.env["HTTP_REFERER"] = root_path
      expect(MailchimpSubscriberWorker)
        .to receive(:perform_async).with(@user.email)
      post :join_newsletter, email_address: @user.email
    end
  end
end
