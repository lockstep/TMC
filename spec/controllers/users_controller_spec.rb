describe UsersController, type: :controller do
  fixtures :users

  let(:michelle) { users(:michelle) }
  let(:paul) { users(:paul) }

  describe '#show' do
    context 'signed in' do
      context 'viewing own account' do
        before do
          sign_in michelle
          get :show, id: michelle.id
        end

        it { expect(response).to render_template('users/show') }
      end
      context "trying to view some other user's account" do
        before do
          sign_in michelle
          get :show, id: paul.id
        end

        it { is_expected.to redirect_to(error_403_path) }
      end
    end
    context 'not signed in' do
      before do
        get :show, id: michelle.id
      end

      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end
end
