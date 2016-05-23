describe Users::MaterialsController, type: :controller do
  fixtures :users

  let(:user)       { users(:michelle) }
  let(:other_user) { users(:paul) }

  describe '#index' do
    context 'not signed in' do
      before do
        get :index, user_id: user.id
      end
      it { is_expected.to redirect_to(new_user_session_path) }
    end
    context 'signed in' do
      before do
        sign_in user
      end
      context 'viewing own account' do
        before do
          get :index, user_id: user.id
        end
        it { expect(response).to render_template('materials/index') }
      end
      context "trying to view some other user's account" do
        before do
          get :index, user_id: other_user.id
        end
        it { is_expected.to redirect_to(error_403_path) }
      end
    end
  end
end
