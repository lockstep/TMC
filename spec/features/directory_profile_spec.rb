feature 'Directory Profile', type: :feature do
  feature 'vendor products shown below profile info' do
    before do
      @vendor = create(:user, opted_in_to_public_directory: true)
      @product = create(:product, vendor: @vendor)
    end
    it 'shows the vendors products on their page' do
      visit directory_profile_path(@vendor)
      expect(page).to have_content @product.name
    end
  end
end
