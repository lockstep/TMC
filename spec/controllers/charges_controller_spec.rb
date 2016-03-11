require 'rails_helper'

RSpec.describe ChargesController, type: :controller do
  fixtures :users
  fixtures :orders
  fixtures :products
  fixtures :line_items
  fixtures :charges

  let(:michelle)         { users(:michelle) }
  let(:buy_cards)        { orders(:buy_cards)}
  let(:buy_cards_charge) {charges(:buy_cards_charge)}

  describe '#show' do
    before do
      get :show, order_id: buy_cards.id, id: buy_cards_charge.id
    end

    it { expect(response).to render_template('charges/show') }
  end

  describe '#new' do
    before do
      get :new, order_id: buy_cards.id
    end

    it {expect(response).to render_template('charges/new') }
  end

  describe '#create' do
    before do
    end
  end
end
