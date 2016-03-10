require 'rails_helper'

RSpec.describe LineItemsController, type: :controller do
  fixtures :line_items
  fixtures :products
  fixtures :orders

  let(:cards_order)       { orders(:cards_order) }
  let(:line_item_cards) { line_items(:line_item_cards) }
  let(:number_cards)    { products(:number_cards) }
  let(:number_board)    { products(:number_board) }

  describe '#create' do
    context 'create new line_item' do
      it 'increase line_item by 1' do
        expect {
          post :create,
               order_id: cards_order.id,
               line_item: {
                product_id: number_board.id,
               }
        }.to change{ LineItem.count }.by(1)
      end

      context '#attributes' do
        before do
          post :create,
               order_id: cards_order.id,
               line_item: {
                product_id: number_board.id,
               }
        end

        it 'have quantity = 1' do
          expect(LineItem.last.quantity).to eq(1)
        end
      end
    end

    context 'existing line_item with same product' do
      it 'increase line_item by 0' do
        expect {
          post :create,
               order_id: cards_order.id,
               line_item: {
                product_id: number_cards.id,
               }
        }.to change{ LineItem.count }.by(0)
      end

      context '#attributes' do
        before do
          post :create,
               order_id: cards_order.id,
               line_item: {
                product_id: number_cards.id,
               }
        end

        it 'increase quantity by 1' do
          expect(line_item_cards.quantity).to eq(3)
        end
      end
    end
  end
end
