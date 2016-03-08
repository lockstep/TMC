describe "products/show" do
  fixtures :products
  fixtures :orders

  let(:number_cards) { products(:number_cards) }
  let(:buy_cards)    { orders(:buy_cards) }

  before do
    assign(:order, Order.find(buy_cards.id))
    assign(:line_item, LineItem.new)
    assign(:product, Product.find(number_cards.id))

    render
  end

  it "display product's name correctly" do
    expect(rendered).to match /#{Regexp.escape(number_cards.name)}/
  end
end
