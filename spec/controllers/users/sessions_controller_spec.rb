describe Users::SessionsController do
  fixtures :users

  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in users(:paul)
  end

  describe '#destroy' do
    it 'clears the stored location for user' do
      session["user_return_to"] = '/my_path'
      delete :destroy
      expect(session["user_return_to"]).to eq root_path
    end
  end
end
