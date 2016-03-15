describe Product, type: :model do
  fixtures :products
  fixtures :presentations
  fixtures :images

  let(:quiz_game)        { presentations(:quiz_game) }
  let(:number_cards)     { products(:number_cards) }
  let(:primary_image)    { images(:primary) }
  let(:secondary_image)  { images(:secondary) }

  describe '#presentations' do
    it 'responds to .presentations call correctly' do
      expect(number_cards.presentations.count).to eq(1)
      expect(number_cards.presentations.first).to eq(quiz_game)
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
end
