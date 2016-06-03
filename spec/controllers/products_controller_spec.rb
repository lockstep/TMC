describe ProductsController, type: :controller do
  fixtures :products
  fixtures :orders

  let(:number_cards)  { products(:number_cards) }
  let(:cards_order)  { orders(:cards_order) }
  let(:cards_order_completed)  { orders(:cards_order_completed) }

  describe '#index' do
    before { get :index }

    it {expect(response).to render_template('products/index')}
  end

  describe '#show' do
    it 'renders the correct template' do
      get :show, id: number_cards.id
      expect(response).to render_template('products/show')
    end
    context 'no session present' do
      it 'creates a new order' do
        expect { get :show, id: number_cards.id }
          .to change{ Order.count }.by 1
        expect(Order.last).to be_active
        expect(session[:order_id]).to eq Order.last.id
      end
    end
    context 'session data present' do
      context 'active order' do
        before do
          session[:order_id] = cards_order.id
        end
        it 'does not create a new order' do
          expect { get :show, id: number_cards.id }
            .to_not change{ Order.count }
          expect(session[:order_id]).to eq cards_order.id
        end
      end
      context 'completed order' do
        before do
          session[:order_id] = cards_order_completed.id
        end
        it 'creates a new order and updates session' do
          expect { get :show, id: number_cards.id }
            .to change{ Order.count }.by 1
          expect(session[:order_id]).to eq Order.last.id
        end
      end
    end
  end
end
