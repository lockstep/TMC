shared_examples 'it sets current order instance' do
  context 'no session present' do
    it 'creates a new order object, does not save it' do
      expect { get :index }.not_to change{ Order.count }
      expect(assigns(:order)).to be_a Order
      expect(session[:order_id]).to eq nil
    end
    context 'session data present' do
      context 'order does not exist (deleted by a rake task)' do
        before do
          session[:order_id] = 0
        end
        it 'creates a new order object' do
          expect { get :index }.not_to change{ Order.count }
          expect(session[:order_id]).to eq nil
          expect(assigns(:order)).to be_active
        end
      end
      context 'active order' do
        before do
          @active_order = orders(:cards_order)
          session[:order_id] = @active_order.id
        end
        it 'does not create a new order' do
          expect { get :index }.not_to change{ Order.count }
          expect(assigns(:order)).to be_a Order
          expect(session[:order_id]).to eq @active_order.id
        end
      end
      context 'completed order' do
        before do
          @completed_order = orders(:cards_order_completed)
          session[:order_id] = @completed_order.id
        end
        it 'creates a new order object' do
          expect { get :index }.not_to change{ Order.count }
          expect(assigns(:order)).to be_a Order
          expect(session[:order_id]).to eq nil
        end
      end
    end
  end
end
