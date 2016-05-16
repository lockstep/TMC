describe 'Manage user account', :devise do
  fixtures :users
  fixtures :line_items
  fixtures :downloadables

  let(:user) { users(:michelle) }

  context 'signed in' do
    before do
      signin(user.email, 'qawsedrf')
    end
    it 'can see and edit user details' do
      visit user_path(user)
      expect(page).to have_content user.email
      click_link 'My Details'
      fill_in_user_form
      expect(page).to have_content user.email
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
        expect(page).to have_link('Animal Cards', href: /my_downloadable_file/)
      end
    end
  end

  def fill_in_user_form
    fill_in 'user[password]', with: 'password'
    fill_in 'user[password_confirmation]', with: 'password'
    click_button 'Save changes'
  end
end
