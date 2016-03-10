describe 'Ordering process', type: :feature do
  fixtures :products
  fixtures :orders

  context 'adding a product to cart' do
    before do
      @product = products(:number_board)
    end
    it 'takes the user to the cart summary' do
      visit product_path @product
      expect(page).to have_content @product.name
      click_button 'Add to Cart'
      expect(page).to have_content 'Your Cart'
      expect(page).to have_css('h5', text: @product.name)
      # check we can't add it again, instead show the right message
      click_link @product.name
      expect(page).not_to have_button 'Add to Cart'
      expect(page).to have_content 'already in your cart'
    end
  end

  context 'removing product from cart' do
    before do
      @product = products(:number_cards)
      @order = orders(:cards_order)
    end
    it 'removes the line item from cart' do
      visit order_path @order
      expect(page).to have_content @product.name
      find(:css, '.btn-danger').click
      expect(page).to have_content 'Your cart is empty'
    end
  end
end
