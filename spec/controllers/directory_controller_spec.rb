describe DirectoryController, type: :request do

  describe '#index' do
    before do
      @user = create(:user, opted_in_to_public_directory: true, address_country: 'CA')
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
  end
end
