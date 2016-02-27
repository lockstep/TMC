require 'rails_helper'

RSpec.describe Sku, type: :model do
  fixtures :skus
  fixtures :materials

  let(:sku)          { skus(:number_cards_sku) }
  let(:number_cards) { materials(:number_cards) }

  describe '#material' do
    it 'respond to .material call correctly' do
      expect(sku.material).to eq(number_cards)
    end
  end
end
