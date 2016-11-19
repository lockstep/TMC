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

    context 'non-downloadable product' do
      before do
        @shipper = users(:shipper)
        @mobile = products(:mobile)
        @mobile.update(vendor: @shipper)
      end
      it 'allows the user to see shipping cost and pay for shipping' do
        visit product_path(@mobile)
        click_on 'Calculate Shipping'
        click_link 'Sign up'
        expect(page).to have_content 'Sign up'
        fill_in 'user[email]', with: 'my@email.com'
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_button 'Sign up'
        fill_in 'user[first_name]', with: 'Tom'
        fill_in 'user[last_name]', with: 'Hanks'
        fill_in 'user[address_line_one]', with: '100 Madeup Ln'
        fill_in 'user[address_city]', with: 'Loveland'
        fill_in 'user[address_state]', with: 'CO'
        fill_in 'user[address_postal_code]', with: '80538'
        select 'France', from: 'user[address_country]'
        click_on 'Save address'
        expect(page).to have_content 'Shipping: $2.48'
        click_on('Add to Cart')
        # Shipping should already be there
        expect(page).to have_content 'Shipping Total $2.48'
        # Total with shipping
        expect(page).to have_content '101.48'
        expect(page).to have_content 'Checkout'
      end
      it 'forces the user to calculate shipping prior to checkout' do
        visit product_path(@mobile)
        # Add straight to cart, don't calculate shipping
        expect(page).to have_content 'Calculate Shipping'
        click_on('Add to Cart')
        click_on 'Log in'
        fill_in('Email', with: user.email)
        fill_in('Password', with: 'qawsedrf')
        click_button('Log in')
        # Shipping is not available yet
        expect(page).to have_content 'Your Cart'
        expect(page).not_to have_content 'Shipping Total'
        expect(page).not_to have_content 'Checkout'
        click_on 'Calculate Shipping'
        fill_in 'user[first_name]', with: 'Tom'
        fill_in 'user[last_name]', with: 'Hanks'
        # Omit first line of address to test validations
        fill_in 'user[address_city]', with: 'Loveland'
        fill_in 'user[address_state]', with: 'CO'
        fill_in 'user[address_postal_code]', with: '80538'
        select 'France', from: 'user[address_country]'
        click_on 'Save address'
        expect(page).to have_content 'be blank'
        fill_in 'user[address_line_one]', with: '100 Madeup Ln'
        click_on 'Save address'
        expect(page).to have_content 'Shipping Total $2.48'
        expect(page).to have_content '101.48'
        expect(page).to have_content 'Checkout'
      end
    end
  end

  def add_product_and_checkout
    visit(product_path(number_board))
    expect(page).not_to have_content 'Shipping'
    click_on('Add to Cart')
    click_on(number_board.name)
    click_on('your cart')
  end
end
