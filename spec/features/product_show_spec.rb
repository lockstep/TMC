describe 'Product show page', type: :feature do
  fixtures :products
  fixtures :topics
  fixtures :downloadables
  fixtures :users

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

  context 'product has a related product' do
    before do
      @product = products(:memory_puzzle_card).reload
      @related_product = products(:flamingo).reload
      @product.related_products << @related_product
    end
    it 'shows breadcrumbs in the right order' do
      expect(@product.reload.related_products).to include @related_product.reload
      visit product_path(@product)
      expect(page).to have_content @related_product.name
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

  context 'free products' do
    before do
      @product = products(:panda)
      allow_any_instance_of(Downloadable).to receive(:download_url)
        .and_return('my_downloadable_file.pdf')
    end
    context 'guest' do
      it 'is prompted to sign in' do
        visit product_path @product
        expect(page).to have_content 'Please sign in or register'
        expect(page).not_to have_link('Download',
                                      href: /my_downloadable_file/)
      end
    end
    context 'signed in user' do
      before do
        @user = users(:michelle)
        signin(@user.email, 'qawsedrf')
      end
      it 'shows download button' do
        visit product_path @product
        expect(page).not_to have_content 'Please sign in or register'
        expect(page).to have_link('Download', href: /my_downloadable_file/)
      end
    end
  end

  context 'external product' do
    before do
      @product = products(:tractor)
    end
    it 'shows external links and not card/shipping' do
      visit product_path @product
      expect(page).to have_content 'Until we can offer'
      expect(page).not_to have_content 'Add to Cart'
      expect(page).to have_link(
        "Recommended Vendor", href: "http://tractors.example.com"
      )
      expect(page).to have_link(
        "Budget Option", href: "http://budget_tractors.example.com"
      )
    end
  end
end
