require 'rails_helper'

RSpec.describe LineItemsController, type: :controller do
  fixtures :line_items
  fixtures :orders

  let(:buy_cards) { orders(:buy_cards) }

  describe '#create' do
  end
end
