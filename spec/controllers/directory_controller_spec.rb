describe DirectoryController, type: :request do

  describe '#index' do
    before do
      @user = create(:user, opted_in_to_public_directory: true,
                     address_country: 'ES')
    end
    it 'returns users in requested format' do
      get '/directory.json'
      profile = response_json['profiles'][0]
      expect(profile['first_name']).to eq 'Jane'
      expect(profile['full_address_country']).to eq 'Canada'
      expect(profile['position_with_organization']).to eq User::POSITIONS.first
      expect(profile['email']).to be_nil
    end
    it 'returns full position with org when present' do
      @user.update(organization_name: 'home')
      get '/directory.json'
      profile = response_json['profiles'][0]
      expect(profile['position_with_organization'])
        .to eq(User::POSITIONS.first + ' at home')
    end
    context 'countries are in a hash' do
      it 'handles the hash appropriately' do
        other_user = create(:user, opted_in_to_public_directory: true)
        get '/directory?utf8=%E2%9C%93&query&countries%5B0%5D=ES&commit=Search'
        users = assigns(:users)
        expect(users).to include @user
        expect(users).not_to include other_user
      end
    end
  end
end
