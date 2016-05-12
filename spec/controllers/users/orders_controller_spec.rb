require 'rails_helper'

RSpec.describe Users::OrdersController, type: :controller do
  fixtures :users
  fixtures :orders
  fixtures :line_items
  fixtures :products

  let(:paul)                         { users(:paul) }
  let(:michelle)                     { users(:michelle) }
  let(:animal_cards_order)           { orders(:animal_cards_order) }
  let(:paid_animal_cards_order)      { orders(:paid_animal_cards_order) }
  let(:cards_order)                  { orders(:cards_order) }

  describe '#index' do
    context 'user\'s signed in and order\'s owner' do
      before do
        sign_in paul
        get :index, user_id: paul.id
      end

      it { expect(response).to render_template('users/orders/index') }
    end

    context 'user\'s signed in but not order\'s owner' do
      before do
        sign_in michelle
        get :index, user_id: paul.id
      end

      it { expect(response).to redirect_to(error_403_path) }
    end

    context 'user\'s not signed in' do
      before { get :index, user_id: paul.id }

      it { expect(response).to redirect_to(error_403_path) }
    end
  end

  describe '#show' do
    context 'user\'s signed in and order\'s owner' do
      before do
        sign_in paul
        get :show, user_id: paul.id, id: paid_animal_cards_order.id
      end

      it { expect(response).to render_template('users/orders/show') }
    end

    context 'user\'s signed in but not order\'s owner' do
      before do
        sign_in paul
        get :show, user_id: paul.id, id: cards_order.id
      end

      it { expect(response).to redirect_to(error_403_path) }
    end

    context 'user\'s not signed in' do
      before do
        get :show, user_id: paul.id, id: animal_cards_order.id
      end

      it { expect(response).to redirect_to(error_403_path) }
    end
  end
end
