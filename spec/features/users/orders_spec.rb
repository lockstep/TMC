describe 'Manage orders', :devise do
  fixtures :users
  fixtures :orders
  fixtures :promotions
  fixtures :adjustments

  before do
    @user = users(:michelle)
  end

  context 'signed in' do
    before do
      signin(@user.email, 'qawsedrf')
      @paid_order = orders(:cards_order_completed)
      @discounted_order = orders(:birds_order_completed)
    end
    it 'can see completed orders' do
      visit user_materials_path(@user)
      click_link 'My Orders'
      find_link(@paid_order.id).click
      # make sure this view is different than checkout
      expect(page).to have_content 'Order Total'
      expect(page).to have_content @paid_order.total
      expect(page).not_to have_css '.fa-trash'
    end
    context 'order with a discount' do
      it 'shows the discount details' do
        visit user_materials_path(@user)
        click_link 'My Orders'
        find_link(@discounted_order.id).click
        expect(page).to have_css('.subtotal',
                                 text: @discounted_order.item_total)
        expect(page).to have_css('.discount',
                                 text: @discounted_order.adjustment_total)
        expect(page).to have_content 'Order Total'
        expect(page).to have_css('.order-total',
                                 text: @discounted_order.total)
      end
    end
  end
end
