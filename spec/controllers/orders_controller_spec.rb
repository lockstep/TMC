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
          it { expect(response).to redirect_to(error_403_path) }
        end
      end
    end

    context 'not signed in' do
      context 'not signed in and not viewing their own order' do
        before do
          get :show, id: other_order.id
        end

        it { expect(response).to redirect_to(new_user_session_path) }
      end
      context 'not signed in and viewing their session order' do
        before do
          @request.session[:order_id] = unassigned_order.id
          get :show, id: @request.session[:order_id]
        end

        it { expect(response).to render_template('orders/show') }
      end
    end
  end

  describe '#success' do
    context 'signed in' do
      before do
        sign_in michelle
      end
      context 'viewing own order' do
        context 'unfinished order' do
          before do
            get :success, id: own_order_unfinished.id
          end
          it { is_expected.to redirect_to(error_403_path) }
        end
        context 'paid order' do
          before do
            get :success, id: own_order_paid.id
          end
          it 'renders the success page' do
            expect(response).to render_template('success')
          end
        end
      end
      context "trying to view some other user's order" do
        before do
          get :success, id: other_order.id
        end
        it { is_expected.to redirect_to(error_403_path) }
      end
    end
    context 'not signed in' do
      before do
        get :success, id: own_order_paid.id
      end
      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end
end
