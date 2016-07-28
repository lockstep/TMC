describe Order, type: :model do
  fixtures :orders
  fixtures :line_items
  fixtures :products
  fixtures :adjustments
  fixtures :promotions

  let(:cards_order) { orders(:cards_order) }

  describe 'adjustment' do
    before do
      @adjustment = adjustments(:cards_order_adjustment)
    end
    it 'loads the associated adjustment' do
      expect(cards_order.adjustment).to eq @adjustment
    end
  end

  describe 'delegation' do
    before do
      @promotion = promotions(:welcome)
      @adjustment = adjustments(:cards_order_adjustment)
    end
    context 'promotion' do
      it 'loads the associated promotion' do
        expect(cards_order.promotion).to eq @promotion
      end
      context 'promotion_code' do
        it 'responds to promotion_code' do
          expect(cards_order.promotion_code).to eq @promotion.code
        end
        it 'returns nil when promotion is absent' do
          order = orders(:birds_order_active)
          expect(order.promotion_code).to be_nil
        end
      end
      context 'promotion_description' do
        it 'responds to promotion_description' do
          expect(cards_order.promotion_description)
            .to eq @promotion.description
        end
        it 'returns nil when promotion is absent' do
          order = orders(:birds_order_active)
          expect(order.promotion_description).to be_nil
        end
      end
    end
    context 'adjustment_amount' do
      it 'loads the correct adjustment amount' do
        expect(cards_order.adjustment_amount).to eq @adjustment.amount
      end
      it 'returns nil if no adjustment exists' do
        order = orders(:birds_order_active)
        expect(order.adjustment_amount).to be_nil
      end
    end
  end

  describe '#adjustment_total' do
    before do
      @adjustment = adjustments(:cards_order_adjustment)
    end
    it 'loads the correct adjustment total' do
      expect(cards_order.adjustment_total).to eq @adjustment.amount
    end
    it 'returns 0 if no adjustment exists' do
      order = orders(:birds_order_active)
      expect(order.adjustment_total).to eq 0
    end
  end

  describe '#item_total' do
    it 'return total price of order correctly' do
      expect(cards_order.item_total).to eq(10.00)
    end
  end

  describe '#total' do
    it 'can handle 0 adjustment correctly' do
      order = orders(:birds_order_active)
      expect(order.total).to eq order.item_total
    end
  end
end
