describe 'Order checkout', type: :feature do
  fixtures :users
  fixtures :orders
  fixtures :products
  fixtures :line_items

  let(:user)          { users(:michelle) }
  let(:cards_order)   { orders(:cards_order) }
  let(:number_cards)  { products(:number_cards) }
  let(:number_board)  { products(:number_board) }

  context 'signed in user' do
    before do
      signin(user.email, 'qawsedrf')
    end

    it 'displays checkout button' do
      add_product_and_checkout
      expect(page).to have_content 'Your Cart'
      expect(page).to have_content number_board.description
      expect(page).to have_link 'Checkout'
    end

    it 'can sign out and still see their cart' do
      add_product_and_checkout
      click_link 'Logout'
      expect(page).to have_content 'Signed out successfully'
      click_link 'My Cart'
      expect(page).to have_content number_board.description
      expect(page).not_to have_content 'is empty'
      expect(page).to have_content 'Log in to check out'
      expect(page).to have_current_path cart_path
    end
  end

  context 'guest user' do
    it 'prompts user to sign in' do
      add_product_and_checkout
      expect(page).to have_content 'Your Cart'
      expect(page).to have_content number_board.description
      expect(page).not_to have_link 'Checkout'
      expect(page).to have_link 'Log in'
    end
  end

  def add_product_and_checkout
    visit(product_path(number_board))
    click_on('Add to Cart')
    click_on(number_board.name)
    click_on('your cart')
  end
end
