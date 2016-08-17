describe 'Free materials', type: :feature do
  fixtures :products
  fixtures :downloadables
  fixtures :users

  before do
    allow_any_instance_of(Downloadable).to receive(:download_url)
      .and_return('my_downloadable_file.pdf')
    @free = products(:panda)
    @user = users(:michelle)
  end

  it 'is accessible from the navbar' do
    visit root_path
    within('#collapsing-navbar') do
      click_link 'Free Materials'
    end
    expect(page).to have_content 'Free Montessori Materials'
  end

  it 'is accessible from the footer' do
    visit root_path
    within('#footer') do
      click_link 'Free Materials'
    end
    expect(page).to have_content 'Free Montessori Materials'
  end

  context 'guest' do
    it 'is prompted to log in or sign up' do
      visit root_path
      within('#footer') do
        click_link 'Free Materials'
      end
      expect(page).to have_content 'Free Montessori Materials'
      expect(page).to have_content 'It only takes 10 seconds'
      expect(page).to have_content @free.name
      expect(page).not_to have_link('Download', href: /my_downloadable_file/)
    end
  end

  context 'signed in user' do
    before do
      signin(@user.email, 'qawsedrf')
    end
    it 'shows free products with signed download URLs' do
      visit root_path
      within('#collapsing-navbar') do
        click_link 'Free Materials'
      end
      expect(page).to have_content 'Free Montessori Materials'
      expect(page).not_to have_content 'It only takes 10 seconds'
      expect(page).to have_content @free.name
      expect(page).to have_link('Download', href: /my_downloadable_file/)
    end
  end
end
