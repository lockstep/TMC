describe 'user register himself', type: :request do
  describe '/api/v1/users' do
    context 'complete information' do
      it 'should return valid response' do
        post "/api/v1/users", user_params
        user = response_json['user']
        expect(user.keys).to include('id')

        user = User.find(user['id'])
        expect(user.first_name).to eq 'test'
        expect(user.last_name).to eq 'example'
        expect(user.position).to eq 'Other'
        expect(user.organization_name).to eq 'Example'
        expect(user.address_city).to eq 'somewhere'
        expect(user.address_state).to eq 'LA'
        expect(user.address_country).to eq 'US'
        expect(user.opted_in_to_public_directory).to eq true
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
        password_confirmation: 'test1234',
        first_name: 'test',
        last_name: 'example',
        position: 'Other',
        organization_name: 'Example',
        address_city: 'somewhere',
        address_state: 'LA',
        address_country: 'US',
        opted_in_to_public_directory: true
      }
    end
  end
end
