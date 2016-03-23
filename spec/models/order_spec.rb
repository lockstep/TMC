describe Order, type: :model do
  fixtures :orders

  let(:cards_order) { orders(:cards_order) }

  describe '.paids' do
    it 'return only paid orders' do
      expect(Order.paids.pluck(:state).uniq).to contain_exactly(1)
    end
  end

  describe '#total_price' do
    it 'return total price of order correctly' do
      expect(cards_order.total_price).to eq(10.00)
    end
  end
end
