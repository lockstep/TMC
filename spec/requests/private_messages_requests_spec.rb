describe 'user fetching private messages', type: :request do
  describe '/api/v1/users/:user_id/private_messages' do
    before { @recipient = create(:user) }
    context '@user is authenticated' do
      before do
        @user = create(:user)
        @message1 = create(
          :private_message, author: @user, feedable: @recipient
        )
      end

      it 'should return message' do
        get "/api/v1/users/#{@recipient.id}/private_messages",
          auth_headers(@user)
        message = response_json['private_messages'][0]
        expect(message['message']).to eq @message1.message
        expect(message['created_time_ago']).not_to eq nil
      end
    end
    context 'unauthenticated user' do
      before do
        get "/api/v1/users/#{@recipient.id}/private_messages"
      end
      it_behaves_like 'an unauthorized request'
    end
  end
end
