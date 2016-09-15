describe Admin::PostsController, type: :controller do
  fixtures :posts
  fixtures :users

  before do
    @admin = users(:michelle)
  end

  describe '#show' do
    before do
      @post = posts(:announcement)
      sign_in @admin
    end
    it 'handles friendly IDs correclty' do
      get :show, id: 'new-hot'
      expect(response.status).to eq 200
    end
  end
end
