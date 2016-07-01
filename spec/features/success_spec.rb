describe 'Order success page', type: :feature do
  fixtures :users
  fixtures :orders

  let (:order) { orders(:cards_order_completed) }

  context 'signed in user' do
    before do
      @user = users(:michelle)
      signin(@user.email, 'qawsedrf')
    end
    context 'session key present' do
      before do
        page.set_rack_session(new_order: true)
      end
      it 'shows the success page' do
        visit success_order_path(order)
        expect(page).to have_content 'Thank you'
        click_link 'Go to my materials'
        expect(page).to have_current_path(user_materials_path(@user))
      end
    end
    context 'no session key' do
      it 'takes the user to materials page' do
        visit success_order_path(order)
        expect(page).to have_current_path(user_materials_path(@user))
      end
    end
  end
  context 'guest user' do
    it 'does not allow access' do
      visit success_order_path(order)
      expect(page).to have_current_path(new_user_session_path)
    end
  end
end
