describe "products/show" do
  fixtures :products
  fixtures :orders
  fixtures :users

  let(:michelle)     { users(:michelle) }
  let(:number_cards) { products(:number_cards) }
  let(:buy_cards)    { orders(:buy_cards) }

  context 'User\'s not signed in' do
    before do
      assign(:product, Product.find(number_cards.id))

      render
    end

    it "display product's name correctly" do
      expect(rendered).to match /#{Regexp.escape(number_cards.name)}/
    end

    it "not display add_to_cart button" do
      expect(rendered).not_to include('Add to cart')
    end
  end

  context 'User\'s signed in' do
    before do
      sign_in michelle

      assign(:order, Order.find(buy_cards.id))
      assign(:line_item, LineItem.new)
      assign(:product, Product.find(number_cards.id))

      render
    end

    it "display add_to_cart button" do
      expect(rendered).to include('Add to cart')
    end
  end
end
