require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  fixtures :users
  fixtures :orders
  fixtures :line_items
  fixtures :products

  let(:michelle)              { users(:michelle) }
  let(:cards_order)           { orders(:cards_order) }
  let(:cards_order_completed) { orders(:cards_order_completed) }
  let(:animal_cards_order)    { orders(:animal_cards_order) }
  let(:unassigned_order)      { orders(:unassigned_order) }

  describe '#show' do
    context 'signed in' do
      before do
        sign_in michelle
      end
      context 'viewing their own order' do
        before do
          get :show, id: cards_order.id
        end

        it { expect(response).to render_template('orders/show') }
      end

      context 'not viewing their own order' do
        before do
          get :show, id: animal_cards_order.id
        end

        it { expect(response).to redirect_to(error_403_path) }
      end
    end

    context 'not signed in' do
      context 'not signed in and not viewing their own order' do
        before do
          get :show, id: animal_cards_order.id
        end

        it { expect(response).to redirect_to(error_403_path) }
      end
      context 'not signed in and viewin their session order' do
        before do
          @request.session[:order_id] = unassigned_order.id
          get :show, id: @request.session[:order_id]
        end

        it { expect(response).to render_template('orders/show') }
      end
    end

    context 'paid order' do
      before do
        sign_in michelle
        get :show, id: cards_order_completed.id
      end
      it { expect(response).to redirect_to(error_403_path) }
    end
  end
end
