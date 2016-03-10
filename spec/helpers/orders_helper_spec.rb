require 'rails_helper'

RSpec.describe OrdersHelper, type: :helper do
  fixtures :orders
  fixtures :products
  fixtures :line_items

  let(:cards_order)    { orders(:cards_order) }

  describe '#total_pricing' do
    before do
      assign(:order, Order.find(cards_order.id))
    end

    it 'include total price correctly' do
      expect(helper.total_pricing).to include('20', 'USD')
    end
  end
end
