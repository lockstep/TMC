describe Order, type: :model do
  fixtures :orders

  let(:cards_order) { orders(:cards_order) }

  describe '#total_price' do
    it 'return total price of order correctly' do
      expect(cards_order.total_price).to eq(10.00)
    end
  end
end
