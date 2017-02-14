describe FeedItemsController do
  describe '#send_message' do
    before do
      @user1 = create(:user, opted_in_to_public_directory: true)
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

      context 'user is not in directory' do
        before { @user1.update(opted_in_to_public_directory: false) }
        it 'redirects them to edit their profile' do
          post :send_message, {
            user_id: @user2.id,
            feed_item: { message: 'my message' }
          }
          expect(response).to redirect_to edit_profile_user_path(@user1.id)
        end
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
