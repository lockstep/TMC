require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
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

        it { expect{ get :index }.to raise_error(ActionController::RoutingError) }
      end

      context 'user\'s not signed in' do
        it { expect{ get :index }.to raise_error(ActionController::RoutingError) }
      end
    end
  end
end
