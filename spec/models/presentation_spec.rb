describe Presentation, type: :model do
  fixtures :topics
  fixtures :presentations
  fixtures :products

  let(:memory_quiz)   { topics(:memory_quiz) }
  let(:quiz_game)     { presentations(:quiz_game) }

  describe '#topic' do
    it 'respond to topic call correctly' do
      expect(quiz_game.topic).to eq memory_quiz
    end
  end

  describe '#products' do
    it 'respond to products call correctly' do
      expect(quiz_game.products.count).to eq 2
    end
  end
end
