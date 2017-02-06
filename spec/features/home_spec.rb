describe 'Home page', type: :feature do
  describe 'free materials button' do
    it 'redirects to the free materials page' do
      visit root_path
      within('#hero') do
        click_link 'Download free materials'
      end
      expect(page).to have_content 'Free Montessori Materials'
    end
  end

  describe 'join newsletter' do
    it 'thanks user for joining' do
      visit root_path
      fill_in :email_address, with: 'test@example.com'
      click_button 'Join Newsletter'
      expect(page).to have_content 'Thank you for subscribing'
    end
    it 'tells if email is blank' do
      visit root_path
      click_button 'Join Newsletter'
      expect(page).to have_content 'Oops'
    end
  end
end
