describe 'Sign up', :feature do
  include_context 'before_after_mailer'

  before { Sidekiq::Testing.inline!  }

  context 'confirming user email', js: true do
    it 'sends the email and logs in the user after confirmation' do
      visit new_user_registration_path
      fill_in 'user[email]', with: 'my@email.com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      click_button 'Sign up'
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      token = User.last.confirmation_token
      expect(ActionMailer::Base.deliveries.last.encoded).to match token
      visit "/users/confirmation?confirmation_token=#{token}"
      expect(page).to have_link 'Logout'
      expect(ActionMailer::Base.deliveries.count).to eq(2)
    end
  end
end
