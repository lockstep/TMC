describe Order, type: :model do
  fixtures :orders

  let(:buy_cards) { orders(:buy_cards) }

  describe '#total_price' do
    it 'return total price of order correctly' do
      expect(buy_cards.total_price).to eq(20.00)
    end
  end
end
