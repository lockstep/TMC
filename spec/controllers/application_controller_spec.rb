describe ApplicationController do
  fixtures :orders

  controller do
    def index
      render nothing: true
    end
  end

  context 'no session present' do
    it 'creates a new order' do
      expect { get :index }.to change{ Order.count }.by 1
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
        expect { get :index }.to change{ Order.count }.by 1
        expect(session[:order_id]).to eq Order.last.id
        expect(Order.last).to be_active
        expect(response.status).to eq 200
      end
    end
    context 'active order' do
      before do
        @active_order = orders(:cards_order)
        session[:order_id] = @active_order.id
      end
      it 'does not create a new order' do
        expect { get :index }.to_not change{ Order.count }
        expect(session[:order_id]).to eq @active_order.id
      end
    end
    context 'completed order' do
      before do
        @completed_order = orders(:cards_order_completed)
        session[:order_id] = @completed_order.id
      end
      it 'creates a new order and updates session' do
        expect { get :index }.to change{ Order.count }.by 1
        expect(session[:order_id]).to eq Order.last.id
      end
    end
  end
end
