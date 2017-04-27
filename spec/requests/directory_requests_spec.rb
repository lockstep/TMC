describe 'retrieving users belong to directory', type: :request do
  describe 'GET /api/v1/directory' do
    context 'users exists' do
      before do
        create(:user)
        create(:user, first_name: 'John', opted_in_to_public_directory: true)
        create(:user, first_name: 'Steve', opted_in_to_public_directory: true)
      end

      it 'should return users that belong to directory' do
        get "/api/v1/directory"
        profiles = response_json['profiles']
        name_list = profiles.map {|p| p['first_name']}
        expect(profiles.size).to eq(2)
        expect(name_list).not_to include 'Jane'
        expect(name_list).to include 'John', 'Steve'
      end

      it 'can search user' do
        get "/api/v1/directory", {query: 'steve'}
        profiles = response_json['profiles']
        expect(profiles.size).to eq(1)
        expect(profiles[0]['first_name']).to eq 'Steve'
      end
    end
  end
end
