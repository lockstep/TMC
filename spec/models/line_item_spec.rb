describe LineItem, type: :model do
  fixtures :orders
  fixtures :adjustments
  fixtures :products

  describe 'hooks' do
    before do
      @order = orders(:cards_order)
    end
    it 'updates order adjustment when line item is destroyed' do
      expect{ @order.line_items.last.destroy }
        .to change{ @order.adjustment_total }.from(1.0).to(0)
    end
    it 'updates order adjustment when line item is created' do
      expect{ LineItem.create(product: products(:flamingo), order: @order) }
        .to change{ @order.adjustment_total }.from(1.0).to(3.0)
    end
  end
end
