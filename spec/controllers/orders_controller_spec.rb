describe OrdersController, type: :controller do
  fixtures :users
  fixtures :orders
  fixtures :line_items
  fixtures :products

  let(:michelle)               { users(:michelle) }
  let(:paul)                   { users(:paul) }
  let(:own_order_unfinished)   { orders(:cards_order) }
  let(:own_order_paid)         { orders(:cards_order_completed) }
  let(:other_order_paid)       { orders(:paid_animal_cards_order) }
  let(:other_order)            { orders(:animal_cards_order) }
  let(:unassigned_order)       { orders(:unassigned_order) }

  describe '#show' do
    context 'signed in' do
      before do
        sign_in michelle
      end
      context 'viewing their own order' do
        before do
          get :show, id: own_order_unfinished.id
        end

        it { expect(response).to render_template('orders/show') }
      end

      context 'not viewing their own order' do
        before do
          get :show, id: other_order.id
        end

        it { expect(response).to redirect_to(error_403_path) }
      end

      context 'paid order' do
        context 'own order' do
          before do
            get :show, id: own_order_paid.id
          end
          it 'takes the user to their order history view' do
            expect(response).to redirect_to(
              user_order_path(michelle, own_order_paid)
            )
          end
        end
        context "somebody else's order" do
          before do
            get :show, id: other_order_paid.id
          end
          it 'denies access' do
            expect(flash[:alert]).to match 'denied'
            expect(response).to redirect_to(error_403_path)
          end
        end
        context 'order does not exist' do
          before do
            get :show, id: 0
          end
          it 'redirects home with an alert' do
            expect(flash[:alert]).to match 'does not exist'
            expect(response).to redirect_to root_path
          end
        end
      end
    end

    context 'not signed in' do
      context 'not signed in and no session data' do
        before do
          get :show, id: other_order.id
        end
        it 'does not allow access' do
          expect(flash[:notice]).to match 'Please log in'
          expect(response).to redirect_to(new_user_session_path)
        end
      end
      context 'not signed in and viewing their session order' do
        before do
          @request.session[:order_id] = own_order_unfinished.id
          get :show, id: @request.session[:order_id]
        end
        it 'shows the order' do
          expect(response).to render_template('orders/show')
        end
      end
    end
  end
end
