describe LineItemsController, type: :controller do
  fixtures :products
  fixtures :orders
  fixtures :line_items
  fixtures :users
  fixtures :promotions
  fixtures :adjustments

  let(:cards_order)     { orders(:cards_order) }
  let(:unassigned_order){ orders(:unassigned_order) }
  let(:number_cards)    { products(:number_cards) }
  let(:number_board)    { products(:number_board) }
  let(:line_item_cards) { line_items(:line_item_cards) }
  let(:user)            { users(:michelle) }

  describe '#create' do
    context 'create new line_item' do
      it 'creates line item' do
        session[:order_id] = cards_order.id
        expect { post :create, line_item: { product_id: number_board.id } }
          .to change{ LineItem.count }.by 1
      end
      context 'signed in user' do
        before do
          sign_in user
          session[:order_id] = unassigned_order.id
          post :create, line_item: { product_id: number_board.id }
        end
        it 'assigns the order to the user' do
          expect(unassigned_order.reload.user).to eq user
        end
      end
    end
    context 'adding a product already in the cart' do
      it 'does not add a new line item' do
        session[:order_id] = cards_order.id
        expect {
          post :create,
            line_item: {
              product_id: number_cards.id,
            }
        }.to change{ LineItem.count }.by 0
      end
    end

    describe '#set_current_order' do
      context 'no session present' do
        it 'creates a new order' do
          expect { post :create, line_item: { product_id: number_board.id } }
            .to change{ Order.count }.by 1
          expect(Order.last).to be_active
          expect(session[:order_id]).to eq Order.last.id
        end
      end
      context 'session data present' do
        context 'order does not exist (deleted by a rake task)' do
          before do
            session[:order_id] = 0
          end
          it 'creates a new order and updates session' do
            expect { post :create, line_item: { product_id: number_board.id } }
              .to change{ Order.count }.by 1
            expect(session[:order_id]).to eq Order.last.id
            expect(Order.last).to be_active
            expect(response).to redirect_to Order.last
          end
        end
        context 'active order' do
          before do
            @active_order = orders(:cards_order)
            session[:order_id] = @active_order.id
          end
          it 'does not create a new order' do
            expect { post :create, line_item: { product_id: number_board.id } }
              .not_to change{ Order.count }
            expect(session[:order_id]).to eq @active_order.id
          end
        end
        context 'completed order' do
          before do
            @completed_order = orders(:cards_order_completed)
            session[:order_id] = @completed_order.id
          end
          it 'creates a new order and updates session' do
            expect { post :create, line_item: { product_id: number_board.id } }
              .to change{ Order.count }.by 1
            expect(session[:order_id]).to eq Order.last.id
          end
        end
      end
    end
  end

  describe '#destroy' do
    context 'line item in cart' do
      it 'removes the line item' do
        session[:order_id] = cards_order.id
        expect { delete :destroy, id: line_item_cards.id }
          .to change{ cards_order.line_items.count }.from(1).to(0)
      end
    end
  end
end
