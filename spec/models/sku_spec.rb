describe Sku, type: :model do
  fixtures :skus
  fixtures :products

  let(:sku)          { skus(:number_cards_sku) }
  let(:number_cards) { products(:number_cards) }

  describe '#product' do
    it 'respond to .product call correctly' do
      expect(sku.product).to eq(number_cards)
    end
  end
end
