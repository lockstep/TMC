require 'rails_helper'

RSpec.describe ChargesController, type: :controller do
  fixtures :users
  fixtures :orders
  fixtures :products
  fixtures :line_items
  fixtures :charges

  let(:michelle)         { users(:michelle) }
  let(:cards_order)        { orders(:cards_order)}
  let(:buy_cards_charge) {charges(:buy_cards_charge)}

  describe '#show' do
    before do
      get :show, order_id: cards_order.id, id: buy_cards_charge.id
    end

    it { expect(response).to render_template('charges/show') }
  end

  describe '#new' do
    before do
      get :new, order_id: cards_order.id
    end

    it {expect(response).to render_template('charges/new') }
  end

  describe '#create' do
    before do
    end
  end
end
