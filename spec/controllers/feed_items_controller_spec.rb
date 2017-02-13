describe FeedItemsController do
  describe '#send_message' do
    before do
      @user1 = create(:user)
      @user2 = create(:user)
      request.env["HTTP_REFERER"] = root_path
    end
    context 'user signed in' do
      before do
        sign_in @user1
        Sidekiq::Testing.inline!
      end
      it 'sends the private message via email' do
        post :send_message, {
          user_id: @user2.id,
          feed_item: { message: 'my message' }
        }
        expect(FeedItems::PrivateMessage.count).to eq 1
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        expect(ActionMailer::Base.deliveries.last.encoded)
          .to match 'my message'
      end
    end
    context 'user is not signed in' do
      it 'redirects' do
        post :send_message, {
          user_id: @user2.id,
          feed_item: { message: 'my message' }
        }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
