describe 'user register himself', type: :request do
  describe '/api/v1/users' do
    context 'complete information' do
      it 'should return valid response' do
        post "/api/v1/users", user_params
        user = response_json['user']
        expect(user.keys).to include('id')
      end
    end

    context 'user exists' do
      before { create(:user, email: 'test@example.com') }
      it 'should return errors when use the existing email' do
        post "/api/v1/users", user_params
        errors = response_json['meta']['errors']
        expect(errors['email']).to include 'already in use'
      end
    end

    def user_params
      {
        email: 'test@example.com',
        password: 'test1234',
        password_confirmation: 'test1234'
      }
    end
  end
end
