describe LineItemsController, type: :controller do
  fixtures :products
  fixtures :orders
  fixtures :line_items

  let(:cards_order)     { orders(:cards_order) }
  let(:number_cards)    { products(:number_cards) }
  let(:number_board)    { products(:number_board) }
  let(:line_item_cards) { line_items(:line_item_cards) }

  describe '#create' do
    context 'create new line_item' do
      it 'creates line item' do
        expect {
          post :create,
            order_id: cards_order.id,
            line_item: {
              product_id: number_board.id,
            }
        }.to change{ LineItem.count }.by 1
      end
    end
    context 'adding a product already in the cart' do
      it 'does not add a new line item' do
        expect {
          post :create,
            order_id: cards_order.id,
            line_item: {
              product_id: number_cards.id,
            }
        }.to change{ LineItem.count }.by 0
      end
    end
  end

  describe '#destroy' do
    context 'line item in cart' do
      it 'removes the line item' do
        expect {
          delete :destroy,
            id: line_item_cards.id,
            order_id: cards_order.id
        }.to change{ cards_order.line_items.count }.from(1).to(0)
      end
    end
  end
end
