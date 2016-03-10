describe Orders::CartHelper, type: :helper do
  fixtures :orders
  fixtures :products
  fixtures :line_items

  let(:number_cards) { products(:number_cards) }
  let(:cards_order)    { orders(:cards_order) }

  describe '#add_to_cart' do
    before do
      assign(:order, Order.find(cards_order.id))
      assign(:product, Product.find(number_cards.id))
    end

    subject { helper.add_to_cart }

    it 'contain order_id' do
      is_expected.to include(cards_order.id.to_s)
    end

    it 'contain product_id' do
      is_expected.to include(number_cards.id.to_s)
    end
  end
end
