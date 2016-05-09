describe 'Product search page', type: :feature do
  fixtures :users
  fixtures :products
  fixtures :orders

  context 'adding a product to cart' do
    before do
      @product = products(:number_board)
    end
    it 'takes the user to the cart summary' do
      visit products_path @product
      expect(page).to have_content @product.name
      expect(page).to have_content @product.price
      find("#add-product-#{@product.id}").click
      expect(page).to have_content 'Your Cart'
      expect(page).to have_css('h5', text: @product.name)
      # check we can't add it again, instead show the right message
      visit products_path @product
      expect(page).not_to have_css "#add-product-#{@product.id}"
      expect(page).to have_content 'Already in your cart'
    end
  end
end
