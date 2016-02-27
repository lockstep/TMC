require 'rails_helper'

RSpec.describe Material, type: :model do
  fixtures :materials
  fixtures :presentations
  fixtures :skus

  let(:quiz_game)        { presentations(:quiz_game) }
  let(:number_cards)     { materials(:number_cards) }
  let(:number_cards_sku) { skus(:number_cards_sku) }

  describe '#presentations' do
    it 'respond to .presentations call correctly' do
      expect(number_cards.presentations.count).to eq(1)
      expect(number_cards.presentations.first).to eq(quiz_game)
    end
  end

  describe '#sku' do
    it 'respond to .sku call correctly' do
      expect(number_cards.sku).to eq(number_cards_sku)
    end
  end
end
