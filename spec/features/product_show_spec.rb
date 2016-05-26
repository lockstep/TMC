describe 'Product show page', type: :feature do
  fixtures :products

  context 'product without a topic' do
    before do
      @product = products(:flamingo)
    end
    it 'does not render breadcrumbs' do
      visit product_path(@product)
      expect(page).to have_content @product.name
      expect(page).to have_content @product.price
      expect(page).not_to have_css('ol.breadcrumb')
    end
  end
end
