require 'rails_helper'

RSpec.describe Topic, type: :model do
  fixtures :topics
  fixtures :presentations

  let(:memory_game)   { topics(:memory_game) }
  let(:memory_quiz)   { topics(:memory_quiz) }
  let(:memory_puzzle) { topics(:memory_puzzle) }

  let(:quiz_game)     { presentations(:quiz_game) }
  describe '#children' do
    it 'have 2 children' do
      expect(memory_game.children.count).to eq 2
    end

    context 'create children' do
      it 'increase children by 1' do
        expect{ memory_game.children.create(name: 'test') }.to(
          change{ memory_game.children.count }.by(1)
        )
      end
    end
  end

  describe '#parent' do
    it 'respond to parent call correctly' do
      expect(memory_quiz.parent).to eq memory_game
      expect(memory_puzzle.parent).to eq memory_game
    end
  end

  describe '#presentations' do
    it 'respond to presentations call correctly' do
      expect(memory_quiz.presentations.count).to eq 1
      expect(memory_quiz.presentations.first).to eq quiz_game
    end
  end
end
