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
end
