describe 'Reset password', :devise do
  fixtures :users

  let(:michelle)  { users(:michelle) }

  context 'reset password' do
    before do
      visit new_user_password_path
      fill_in('Email', with: michelle.email)
      click_button('Send me password instructions')
    end
    context 'user signed in with valid password' do
      it 'user can edit profile normally' do
        signin(michelle.email, 'qawsedrf')
        visit edit_profile_users_path
        fill_in 'user[first_name]', with: 'm'
        click_button 'Save profile'
        expect(page).to have_content 'has been updated'
      end
    end
    context 'without clearing reset password token' do
      before do
        allow_any_instance_of(User).to receive(:clear_devise_reset_password_token)
      end
      context 'user signed in with valid password' do
        it 'user cannot edit profile normally' do
          signin(michelle.email, 'qawsedrf')
          visit edit_profile_users_path
          fill_in 'user[first_name]', with: 'm'
          click_button 'Save profile'
          expect(page).not_to have_content 'has been updated'
        end
      end
    end
  end
end
