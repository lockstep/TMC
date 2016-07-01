describe 'Error pages', type: :feature do
  context 'record not found' do
    it 'redirects to 404' do
      visit order_path 0
      expect(page).to have_content 'does not exist'
      expect(page).to have_link 'Keep shopping'
    end
  end
  context 'page not found' do
    it 'redirects to 404' do
      visit '/made-up-path'
      expect(page).to have_content 'does not exist'
      expect(page).to have_link 'Keep shopping'
    end
  end
end
