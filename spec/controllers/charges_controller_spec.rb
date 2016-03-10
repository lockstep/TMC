require 'rails_helper'

RSpec.describe ChargesController, type: :controller do
  fixtures :users
  fixtures :orders
  fixtures :products
  fixtures :line_items

  let(:michelle)  { users(:michelle) }
  let(:cards_order) { orders(:cards_order)}

  describe '#new' do
    context 'user\'s signed in' do
      before do
        sign_in michelle
        get :new, order_id: cards_order.id
      end

      it {expect(response).to render_template('charges/new')}
    end

    context 'user\'s not signed in' do
      before do
        get :new, order_id: cards_order.id
      end

      it {expect(response).to redirect_to(new_user_session_path)}
    end
  end

  describe '#create' do
  end
end
