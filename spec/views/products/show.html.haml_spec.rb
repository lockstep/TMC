describe "products/show" do
  fixtures :products
  fixtures :orders

  let(:number_cards) { products(:number_cards) }
  let(:cards_order)    { orders(:cards_order) }

  context 'product show page' do
    before do
      assign(:order, Order.find(cards_order.id))
      assign(:product, Product.find(number_cards.id))
      render
    end

    it "displays product's name correctly" do
      expect(rendered).to match number_cards.name
    end
  end
end
