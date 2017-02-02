xfeature 'Bambini pilot registration' do
  fixtures :users
  fixtures :orders
  fixtures :products
  fixtures :line_items

  let(:user)          { users(:michelle) }
  let(:cards_order)   { orders(:cards_order) }
  let(:number_cards)  { products(:number_cards) }
  let(:number_board)  { products(:number_board) }
  context 'all info provided' do
    scenario 'user registers successfully' do
      visit root_path
      click_link 'Bambini Pilot'
      fill_in('Email', with: user.email)
      fill_in('Password', with: 'qawsedrf')
      click_button('Log in')
      expect(page).not_to have_content 'new adventure'
      fill_in 'user[first_name]', with: 'Tom'
      fill_in 'user[last_name]', with: 'Hanks'
      fill_in 'user[organization_name]', with: 'TMC'
      select 'Teacher', from: 'user[position]'
      click_on 'Join Pilot'
      expect(page).to have_content 'new adventure'
    end
  end
  context 'missing values' do
    scenario 'user needs to add all values then may register' do
      visit root_path
      click_link 'Bambini Pilot'
      fill_in('Email', with: user.email)
      fill_in('Password', with: 'qawsedrf')
      click_button('Log in')
      expect(page).not_to have_content 'new adventure'
      fill_in 'user[first_name]', with: 'Tom'
      click_on 'Join Pilot'
      expect(page).to have_content 'are required'
      fill_in 'user[first_name]', with: 'Tom'
      fill_in 'user[last_name]', with: 'Hanks'
      fill_in 'user[organization_name]', with: 'TMC'
      select 'Teacher', from: 'user[position]'
      click_on 'Join Pilot'
      expect(page).to have_content 'new adventure'
    end
  end
end
