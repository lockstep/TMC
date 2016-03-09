require 'rails_helper'

RSpec.describe ChargesController, type: :controller do
  fixtures :users
  fixtures :orders
  fixtures :products
  fixtures :line_items

  let(:michelle)  { users(:michelle) }
  let(:buy_cards) { orders(:buy_cards)}

  describe '#new' do
    context 'user\'s signed in' do
      before do
        sign_in michelle
        get :new, order_id: buy_cards.id
      end

      it {expect(response).to render_template('charges/new')}
    end

    context 'user\'s not signed in' do
      before do
        get :new, order_id: buy_cards.id
      end

      it {expect(response).to redirect_to(new_user_session_path)}
    end
  end

  describe '#create' do
    before do
    end
  end
end
