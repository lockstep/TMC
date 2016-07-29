describe 'Ordering process', type: :feature do
  fixtures :users
  fixtures :products
  fixtures :line_items
  fixtures :orders
  fixtures :promotions
  fixtures :adjustments

  context 'my cart' do
    it 'the link is always displayed' do
      visit root_url
      click_link 'My Cart'
      expect(page).to have_content 'cart is empty'
    end
  end

  context 'adding a product to cart' do
    before do
      @product = products(:number_board)
      LineItem.destroy_all
    end

    it 'takes the user to the cart summary' do
      visit product_path @product
      expect(page).to have_content @product.name
      expect(page).to have_content @product.price
      click_button 'Add to Cart'
      expect(page).to have_content 'Your Cart'
      expect(page).to have_css('h5', text: @product.name)
      expect(page).to have_content 'Order Total'
      expect(page).to have_css('.order-total', text: @product.price)
      # check we can't add it again, instead show the right message
      click_link @product.name
      expect(page).not_to have_button 'Add to Cart'
      expect(page).to have_content 'already in your cart'
    end
  end

  context 'promo code' do
    before do
      @user = users(:michelle)
      signin(@user.email, 'qawsedrf')
    end
    context 'order with an existing adjustment' do
      before do
        @order = orders(:cards_order)
      end
      it 'lets the user see the coupon' do
        visit order_path @order
        expect(page).not_to have_content 'has been applied'
        expect(page).to have_css('.subtotal', text: @order.item_total)
        expect(page).to have_css('.discount', text: @order.adjustment_total)
        expect(page).to have_css('.description',
                                 text: @order.promotion_description)
      end
    end
    context 'order without adjustment' do
      before do
        @order = orders(:birds_order_active)
      end
      it 'lets the user see the coupon they apply' do
        visit order_path @order
        expect(page).not_to have_content 'Subtotal'
        fill_in :code, with: 'WELCOME'
        click_button 'Apply'
        expect(page).to have_content 'has been applied'
        expect(page).to have_css('.subtotal', text: @order.item_total)
        expect(page).to have_css('.discount', text: @order.adjustment_total)
        expect(page).to have_css('.description',
                                 text: @order.promotion_description)
      end
    end
  end

  context 'checkout button' do
    before do
      @user = users(:michelle)
      @order = orders(:cards_order)
      signin(@user.email, 'qawsedrf')
    end
    it 'prepopulates the email field' do
      visit order_path @order
      expect(find('#stripeEmail', visible: false).value).to eq @user.email
    end
  end

  context 'removing product from cart' do
    before do
      @michelle = users(:michelle)
      @product = products(:number_cards)
      @order = orders(:cards_order)
      signin(@michelle.email, 'qawsedrf')
    end
    it 'removes the line item from cart' do
      visit order_path @order
      expect(page).to have_content @product.name
      find(:css, '.btn-danger').click
      expect(page).to have_content 'Your cart is empty'
      expect(page).not_to have_link 'Checkout'
    end
  end
end
