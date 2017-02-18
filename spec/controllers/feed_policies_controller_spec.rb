describe FeedPoliciesController do
  describe '#toggle_private_messages_enabled' do
    before do
      @user1 = create(:user, opted_in_to_public_directory: true)
      @user2 = create(:user)
      request.env["HTTP_REFERER"] = directory_profile_path(@user1)
    end
    context 'user signed in' do
      before { sign_in @user1 }
      context 'signed in user is not authorized' do
        it 'redirects' do
          patch :toggle_private_messages_enabled, {
            user_id: @user2.id
          }
          expect(response).to redirect_to root_path
        end
      end
    end
    context 'user is not signed in' do
      it 'redirects' do
        patch :toggle_private_messages_enabled, {
          user_id: @user2.id
        }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
