require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  fixtures :users
  fixtures :orders
  fixtures :line_items
  fixtures :products

  let(:michelle)    { users(:michelle) }
  let(:cards_order) { orders(:cards_order) }

  describe '#show' do
    before { get :show, id: cards_order.id }

    it { expect(response).to render_template('orders/show') }
  end
end
