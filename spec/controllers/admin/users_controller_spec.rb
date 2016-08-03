describe Admin::UsersController, type: :controller do
  fixtures :users

  let(:michelle) { users(:michelle) }
  let(:paul)     { users(:paul) }

  context 'restrict access to admin only' do
    describe '#index' do
      context 'user\'s signed in as an admin' do
        before do
          sign_in michelle
          get :index
        end

        it { expect(response.status).to eq(200) }
      end

      context 'user\'s signed in as a user' do
        before { sign_in paul }

        it 'redirects home with a flash alert' do
          get :index
          expect(response).to redirect_to root_path
          expect(flash[:alert]).to eq 'Not authorized.'
        end
      end

      context 'user\'s not signed in' do
        it 'redirects home with a flash alert' do
          get :index
          expect(response).to redirect_to root_path
          expect(flash[:alert]).to eq 'Not authorized.'
        end
      end
    end
  end
end
