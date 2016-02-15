require 'rails_helper'

RSpec.describe Topic, type: :model do
  fixtures :topics

  let(:memory_game)   { topics(:memory_game) }
  let(:memory_quiz)   { topics(:memory_quiz) }
  let(:memory_puzzle) { topics(:memory_puzzle) }

  describe '#children' do
    it 'should have 2 children' do
      expect(memory_game.children.count).to eq 2
    end

    context 'create children' do
      it 'should increase children by 1' do
        expect{ memory_game.children.create(name: 'test') }.to(
          change{ memory_game.children.count }.by(1)
        )
      end
    end
  end

  describe '#parent' do
    it 'should respond to parent call correctly' do
      expect(memory_quiz.parent).to eq memory_game
      expect(memory_puzzle.parent).to eq memory_game
    end
  end
end
