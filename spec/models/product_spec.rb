describe Product, type: :model do
  fixtures :products
  fixtures :presentations

  let(:quiz_game)        { presentations(:quiz_game) }
  let(:number_cards)     { products(:number_cards) }

  describe '#presentations' do
    it 'respond to .presentations call correctly' do
      expect(number_cards.presentations.count).to eq(1)
      expect(number_cards.presentations.first).to eq(quiz_game)
    end
  end
end
