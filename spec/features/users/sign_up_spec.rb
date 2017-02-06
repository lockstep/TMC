describe 'Sign up', :feature do
  fixtures :products

  include_context 'before_after_mailer'

  before do
    Product.reindex
    allow(MailchimpSubscriberWorker).to receive(:perform_async)
  end

  context 'registration', js: true do
    it 'sends the welcome email and logs in the user' do
      visit new_user_registration_path
      fill_in 'user[email]', with: 'my@email.com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      click_button 'Sign up'
      expect(page).to have_content 'Welcome! You have signed up'
      expect(ActionMailer::Base.deliveries.count).to eq 1
      expect(MailchimpSubscriberWorker).to have_received(:perform_async)
        .with(User.last.email)
      email = ActionMailer::Base.deliveries.first
      expect(email.subject).to eq 'Welcome to The Montessori Company'
      visit root_path
      expect(page).to have_link 'Logout'
    end
  end

  context 'failed registration', js: true do
    it 'does not attempt to send the welcome email' do
      visit new_user_registration_path
      fill_in 'user[email]', with: 'my@email.com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'does_not_match'
      click_button 'Sign up'
      expect(page).to have_content "doesn't match"
      expect(page).not_to have_content 'prohibited this user'
      expect(ActionMailer::Base.deliveries.count).to eq 0
      expect(MailchimpSubscriberWorker).not_to have_received(:perform_async)
    end
  end
end
