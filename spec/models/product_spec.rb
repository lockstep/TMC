describe Product, type: :model do
  fixtures :products
  fixtures :presentations
  fixtures :downloadables
  fixtures :images
  fixtures :topics
  fixtures :line_items
  fixtures :orders

  let(:quiz_game)        { presentations(:quiz_game) }
  let(:number_cards)     { products(:number_cards) }
  let(:primary_image)    { images(:primary) }
  let(:secondary_image)  { images(:secondary) }

  it 'validates min and max shipping if fulfilled via shipment' do
    p = Product.new
    expect(p).to be_valid
    p.fulfill_via_shipment = true
    expect(p).not_to be_valid
    p.min_shipping_cost_cents = 1
    p.max_shipping_cost_cents = 2
    expect(p).to be_valid
  end

  describe '#presentation' do
    it 'returns the presentation it belongs to' do
      expect(number_cards.presentation).to eq quiz_game
    end
  end

  describe '#topics' do
    before do
      @topic = topics(:memory_quiz)
    end
    it 'returns the topic it belongs to' do
      expect(number_cards.topics).to include @topic
    end
  end

  describe '#primary_image' do
    it 'returns primary image' do
      expect(number_cards.primary_image).to eq primary_image
    end
  end

  describe '#images' do
    it 'returns the images array' do
      expect(number_cards.images.count).to eq 2
      expect(number_cards.images).to include primary_image, secondary_image
    end
  end

  describe '#featured' do
    before do
      @featured = products(:flamingo)
    end
    it 'returns an array of featured products' do
      expect(Product.featured.size).to eq 1
      expect(Product.featured).to include @featured
    end
  end

  describe '#free' do
    before do
      @free = products(:panda)
    end
    it 'returns an array of featured products' do
      expect(Product.free.size).to eq 1
      expect(Product.free).to include @free
    end
  end

  describe '#with_downloadables' do
    before do
      @without_downloadable = products(:flamingo)
      @with_downloadable = products(:animal_cards)
    end
    it 'returns an array of products with downloadables' do
      expect(Product.with_downloadables.size).to eq 5
      expect(Product.with_downloadables).to include @with_downloadable
    end
  end

  describe '#topic_ids_array' do
    before do
      @product = products(:ostrich)
      @parent_topic = topics(:animals)
      @child_topic1 = topics(:birds)
      @child_topic2 = topics(:cards)
    end
    it 'returns an array of numbers without duplicates' do
      expect(@product.topic_ids_array.size).to eq 3
      expect(@product.topic_ids_array).to include @parent_topic.id
      expect(@product.topic_ids_array).to include @child_topic1.id
      expect(@product.topic_ids_array).to include @child_topic2.id
    end
  end

  describe '#topic_name' do
    before do
      @product_with_topic = products(:animal_cards)
      @product_without_topic = products(:flamingo)
    end
    it 'returns topic name if topic is present' do
      expect(@product_with_topic.topic_name).to eq 'Memory Quiz'
    end
    it 'defaults to Digital Products' do
      expect(@product_without_topic.topic_name).to eq 'Digital Products'
    end
  end

  describe '#times_sold' do
    it 'returns the right value' do
      has_sales = products(:flamingo)
      no_sales = products(:ostrich)
      expect(has_sales.times_sold).to eq 2
      expect(no_sales.times_sold).to eq 0
    end
  end
end
