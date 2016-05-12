describe 'Manage orders', :devise do
  fixtures :users
  fixtures :orders

  before do
    @user = users(:michelle)
  end

  context 'signed in' do
    before do
      signin(@user.email, 'qawsedrf')
      @paid_order = orders(:cards_order_completed)
    end
    it 'can see completed orders' do
      visit user_path(@user)
      click_link 'My Orders'
      find_link(@paid_order.id).click
      # make sure this view is different than checkout
      expect(page).to have_content 'Order total'
      expect(page).to have_content @paid_order.total_price
      expect(page).not_to have_css '.fa-trash'
    end
  end
end
