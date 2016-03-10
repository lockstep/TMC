describe "products/show" do
  fixtures :products
  fixtures :orders
  fixtures :users

  let(:michelle)     { users(:michelle) }
  let(:number_cards) { products(:number_cards) }
  let(:cards_order)    { orders(:cards_order) }

  context 'User\'s not signed in' do
    before do
      assign(:order, Order.find(cards_order.id))
      assign(:line_item, LineItem.new)
      assign(:product, Product.find(number_cards.id))
      render
    end

    it "display product's name correctly" do
      expect(rendered).to match /#{Regexp.escape(number_cards.name)}/
    end

    it "not display add_to_cart button" do
      expect(rendered).to include('Add to cart')
    end
  end

  context 'User\'s signed in' do
    before do
      sign_in michelle

      assign(:order, Order.find(cards_order.id))
      assign(:line_item, LineItem.new)
      assign(:product, Product.find(number_cards.id))

      render
    end

    it "display add_to_cart button" do
      expect(rendered).to include('Add to cart')
    end
  end
end
