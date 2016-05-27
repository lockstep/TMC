describe 'Product show page', type: :feature do
  fixtures :products
  fixtures :topics

  context 'product without a topic' do
    before do
      @product = products(:flamingo)
    end
    it 'has the link to Products as the only breadcrumb' do
      visit product_path(@product)
      expect(page).to have_content @product.name
      expect(page).to have_content @product.price
      within('ol.breadcrumb') do
        expect(page).to have_link 'Products'
      end
    end
  end

  context 'product belongs to a topic' do
    before do
      @product = products(:memory_puzzle_card)
      @parent_topic = topics(:memory_game)
      @child_topic = topics(:memory_puzzle)
    end
    it 'shows breadcrumbs in the right order' do
      visit product_path(@product)
      within('ol.breadcrumb') do
        # orderly will match the meta tag text, so better use paths
        # instead of breadcrumb link texts
        expect(products_path)
          .to appear_before products_path(topic_ids: @parent_topic.id)
        expect(products_path(topic_ids: @parent_topic.id))
          .to appear_before products_path(topic_ids: @child_topic.id)
      end
    end
  end
end
