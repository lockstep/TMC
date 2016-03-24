describe 'Display stripe button', js: true, type: :feature do
  fixtures :users
  fixtures :orders
  fixtures :products
  fixtures :line_items

  let(:michelle)      { users(:michelle) }
  let(:cards_order)   { orders(:cards_order) }
  let(:number_cards)  { products(:number_cards) }
  let(:number_board) { products(:number_board) }

  before do
    signin(michelle.email, 'qawsedrf')
    visit(order_path(cards_order))
  end

  it 'display stripe button' do
    expect(page).to have_content('Pay with Card')
  end

  it 'display stripe button after click through turbolinks' do
    visit(product_path(number_board))
    click_on('Add to Cart')
    click_on(number_board.name)
    click_on('your cart')
    expect(page).to have_content 'Your Cart'
    expect(page).to have_content number_board.description
    expect(page).to have_content('Pay with Card')
  end
end
