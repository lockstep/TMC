describe 'Manage user account', :devise do
  fixtures :users
  fixtures :products
  fixtures :line_items
  fixtures :downloadables

  let(:user)  { users(:michelle) }
  let(:cards) { products(:animal_cards) }

  context 'signed in' do
    before do
      signin(user.email, 'qawsedrf')
    end
    it 'can see and edit user details' do
      visit user_path(user)
      expect(page).to have_content user.email
      click_link 'My Details'
      fill_in_user_form
      expect(page).to have_content 'DJ Shadow'
      expect(page).to have_content 'have been updated'
    end

    context 'materials' do
      before do
        allow_any_instance_of(Downloadable).to receive(:download_url)
          .and_return('my_downloadable_file.pdf')
      end
      it 'can see materials' do
        visit user_path(user)
        click_link 'My Materials'
        expect(page).to have_link('Download', href: /my_downloadable_file/)
        expect(page).to have_link(cards.name, href: product_path(cards))
        expect(page).to have_link(cards.presentation.name,
                                  href: presentation_path(cards.presentation))
      end
    end
  end

  def fill_in_user_form
    fill_in 'user[first_name]', with: 'DJ Shadow'
    fill_in 'user[password]', with: 'password'
    fill_in 'user[password_confirmation]', with: 'password'
    click_button 'Save changes'
  end
end
