describe 'Product search page', type: :feature do
  fixtures :users
  fixtures :products
  fixtures :orders
  fixtures :topics

  before do
    @product = products(:number_board)
  end

  context 'topics list' do
    before do
      @topic_1 = topics(:birds)
      @topic_2 = topics(:memory_game)
      @child_topic_1 = topics(:memory_quiz)
      @child_topic_2 = topics(:memory_puzzle)
    end
    it 'shows parent and children topics in the right order' do
      visit products_path
      expect(@topic_1.name).to appear_before @topic_2.name
      expect(@child_topic_1.name).to appear_before @child_topic_2.name
    end
    it 'shows product counts next to Topic names' do
      products_count = Product.search(where: { topic_ids: [@topic_2.id] }).count
      visit products_path
      expect(page).to have_link "#{@topic_2.name} (#{products_count})"
    end
    it 'opens the tree node for active topic and highlights it', js: true do
      visit products_path
      expect(page).not_to have_content @child_topic_2.name
      click_link @topic_2.name
      expect(page).to have_content @child_topic_2.name.upcase
      expect(page).to have_selector('a.active', text: @topic_2.name.upcase)
    end
  end

  context 'adding a product to cart' do
    it 'takes the user to the cart summary' do
      visit products_path
      expect(page).to have_content @product.name
      expect(page).to have_content @product.price
      find("#add-product-#{@product.id}").click
      expect(page).to have_content 'Your Cart'
      expect(page).to have_css('h5', text: @product.name)
      # check we can't add it again, instead show the right message
      visit products_path @product
      expect(page).not_to have_css "#add-product-#{@product.id}"
      expect(page).to have_content 'Already in your cart'
    end
  end

  context 'search' do
    context 'price range' do
      it 'persists the setting and shows the correct results', js: true do
        visit products_path
        page.execute_script("$('#price-range').val('11;33');")
        find("#search-button").click
        expect(page).to have_css('.irs-from', text: '$11')
        expect(page).to have_css('.irs-to', text: '$33')
        expect(page).to have_content 'Number Board'.upcase
        expect(page).to have_content 'Animal Cards'.upcase
        # do not include the product with price $10
        expect(page).not_to have_content 'Number Cards'.upcase
      end
    end
    context 'search by topics' do
      before do
        @no_presentation = products(:flamingo)
      end
      it 'shows all products without search options' do
        visit products_path
        expect(page).to have_content @no_presentation.name
        click_link Topic.first.name
        # the product with no presentation is not shown
        expect(page).not_to have_content @no_presentation.name
      end
      context 'other options are set' do
        before do
          @birds = topics(:birds)
          @ostrich = products(:ostrich)
          @cards = products(:number_cards)
        end
        it 'persists topic selection when other options are set' do
          visit products_path
          click_link @birds.name
          expect(page).to have_content @ostrich.name
          select('Price: lowest first', :from => 'sort')
          expect(page).to have_content @ostrich.name
          # topic stays narrowed down to Birds
          expect(page).not_to have_content @cards.name
        end
      end
    end
  end

  context 'recently viewed' do
    it 'lists the recently viewed products' do
      # make sure the visited product is listed, but only once
      visit products_path
      expect(page).to have_content 'None yet :('
      visit product_path @product
      click_link 'Back to search'
      within('#recently-viewed') do
        expect(page).to have_content @product.name
      end
    end
  end
end
