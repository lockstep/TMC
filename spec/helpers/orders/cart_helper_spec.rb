require 'rails_helper'

RSpec.describe Orders::CartHelper, type: :helper do
  fixtures :orders
  fixtures :products
  fixtures :line_items

  let(:number_cards) { products(:number_cards) }
  let(:buy_cards)    { orders(:buy_cards) }

  describe '#add_to_cart' do
    before do
      assign(:order, Order.find(buy_cards.id))
      assign(:line_item, LineItem.new)
      assign(:product, Product.find(number_cards.id))
    end

    subject { helper.add_to_cart }

    it 'contain order_id' do
      is_expected.to include(buy_cards.id.to_s)
    end

    it 'contain product_id' do
      is_expected.to include(number_cards.id.to_s)
    end
  end
end
