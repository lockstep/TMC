describe 'Manage user account', :devise do
  fixtures :users
  fixtures :products
  fixtures :line_items
  fixtures :downloadables

  let(:user)  { users(:michelle) }
  let(:cards) { products(:animal_cards) }
  let(:bird)  { products(:flamingo) }

  context 'signed in' do
    before do
      signin(user.email, 'qawsedrf')
    end
    it 'can see and edit user details' do
      visit user_materials_path(user)
      click_link 'My Details'
      fill_in_user_form
      expect(page).to have_content 'have been updated'
    end

    context 'materials' do
      before do
        allow_any_instance_of(Downloadable).to receive(:download_url)
          .and_return('my_downloadable_file.pdf')
      end
      it 'can see materials' do
        visit user_materials_path(user)
        expect(page).to have_link('Download', href: /my_downloadable_file/)
        expect(page).to have_link(cards.name, href: product_path(cards))
        expect(page).to have_link(bird.name, href: product_path(bird))
      end
    end
  end

  context 'not signed in' do
    it 'takes the user to the materials page after signing in' do
      visit user_materials_path(user)
      expect(page).to have_content "Welcome Back"
      signin(user.email, 'qawsedrf')
      expect(page).to have_content "My Materials"
    end
  end

  def fill_in_user_form
    fill_in 'user[first_name]', with: 'DJ Shadow'
    fill_in 'user[password]', with: 'password'
    fill_in 'user[password_confirmation]', with: 'password'
    click_button 'Save changes'
  end
end
