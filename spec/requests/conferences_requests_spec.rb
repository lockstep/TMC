describe 'user fetching conference data', type: :request do
  describe '/api/v1/conferences/:id' do
    before { @conference = create(:conference) }
    context '@user is authenticated' do
      before { @user = create(:user) }

      it 'should return conference data' do
        get "/api/v1/conferences/#{@conference.id}", auth_headers(@user)
        conference = response_json['conference']
        expect(conference['name']).to eq @conference.name
      end
    end
    context 'unauthenticated user' do
      before do
        get "/api/v1/conferences/#{@conference.id}"
      end
      it_behaves_like 'an unauthorized request'
    end
  end
end
