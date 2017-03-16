describe 'Api::V1::Users::SessionsController', type: :request do

  shared_examples 'a bad auth request' do
    it 'has the correct message' do
      expect(response_json['meta']['errors']['auth'][0]).to match 'Invalid'
    end
    it_behaves_like 'an unauthorized request'
  end

  describe 'POST /users/sign_in' do
    context 'the user exists' do
      before { @user = create(:user, email: 't@e.com', password: 'password') }
      context 'the params are correct' do
        before do
          post "/api/v1/users/sign_in", auth_params
        end
        it 'returns auth headers' do
          expect(response.headers['access-token']).to be_present
        end
        it_behaves_like 'a successful resource request', 'user'

      end
    end
    context 'the user does not exist' do
      before { post "/api/v1/users/sign_in", auth_params }
      it_behaves_like 'a bad auth request'
    end
  end

  describe 'DELETE /users/sign_out' do
    context 'the user exists' do
      before { @user = create(:user, email: 't@e.com', password: 'password') }
      context 'user is logged in' do
        before do
          delete "/api/v1/users/sign_out", { email: "t@e.com" },
            auth_headers(@user)
        end
        it 'returns the correct status code' do
          expect(response.code).to eq '200'
        end
      end
      context 'user is not logged in' do
        before { delete "/api/v1/users/sign_out", { email: "t@e.com" } }
        it 'returns the appropriate error' do
          expect(response_json['meta']['errors']['auth'][0]).to match 'logged'
        end
        it_behaves_like 'a resource was not found'
      end
    end
    context 'user does not exist' do
      before { delete "/api/v1/users/sign_out", { email: "t@e.com" } }
      it_behaves_like 'a resource was not found'
    end
  end

  def auth_params(overrides={})
    {
      email: overrides[:email] || 't@e.com',
      password: overrides[:password] || 'password'
    }
  end
end

