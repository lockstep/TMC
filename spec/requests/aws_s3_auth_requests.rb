describe 'user get AWS credentials', type: :request do
  describe 'GET /api/v1/aws_s3_auth' do
    context '@user is authenticated' do
      before { @user = create(:user) }
      it 'should return AWS credentials' do
        get "/api/v1/aws_s3_auth",
          { filename: 'abc.jpg', content_type: 'image/jpg' },
          auth_headers(@user)
        credentials = response_json['credentials']
        expect(credentials['key']).to match('abc.jpg')
        expect(credentials['acl']).to match('public-read')
      end
    end
    context 'unauthenticated user' do
      before do
        get "/api/v1/aws_s3_auth",
          { filename: 'abc.jpg', content_type: 'image/jpg' }
      end
      it_behaves_like 'an unauthorized request'
    end
  end
end
