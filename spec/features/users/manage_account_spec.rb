describe 'Manage user account', :devise do
  fixtures :users

  let(:michelle) { users(:michelle) }

  context 'signing in' do
    before do
      signin(michelle.email, 'qawsedrf')
    end
    it 'can see and edit user details' do
      visit user_path(michelle)
      expect(page).to have_content michelle.email
      click_link 'Edit'
      fill_in_user_form
      expect(page).to have_content michelle.email
      expect(page).to have_content 'have been updated'
    end
  end

  def fill_in_user_form
    fill_in 'user[password]', with: 'password'
    fill_in 'user[password_confirmation]', with: 'password'
    click_button 'Save changes'
  end
end
