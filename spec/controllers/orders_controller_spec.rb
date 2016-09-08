describe OrdersController, type: :controller do
  fixtures :users
  fixtures :orders
  fixtures :line_items
  fixtures :products
  fixtures :promotions
  fixtures :adjustments

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
          session[:order_id] = own_order_unfinished.id
          get :show, id: session[:order_id]
        end
        it 'shows the order' do
          expect(response).to render_template('orders/show')
        end
      end
    end
  end

  describe '#success' do
    context 'signed in user' do
      before do
        sign_in michelle
      end
      context 'newly paid order' do
        before do
          session[:new_order] = true
        end
        it 'renders the success page' do
          get :success, id: own_order_paid.id
          expect(response).to render_template('success')
          expect(session[:new_order]).to be_nil
        end
      end
      context 'repeated access to success page' do
        it 'takes the user to the materials page' do
          get :success, id: own_order_paid.id
          expect(response).to redirect_to user_materials_path(michelle)
        end
      end
    end
    context 'guest user' do
      it 'prompts user to log in' do
        get :success, id: own_order_paid.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#update' do
    context 'signed in user' do
      before do
        sign_in michelle
      end
      context 'promotion not found' do
        before do
          @order = orders(:birds_order_active)
        end
        it 'redirects to order page with a message' do
          patch :update, id: @order.id, code: 'ha'
          expect(response).to redirect_to order_path @order
          expect(flash[:alert]).to match 'does not exist'
          expect(@order.adjustment).to be_nil
        end
      end
      context 'promotion inactive' do
        before do
          @order = orders(:birds_order_active)
        end
        it 'redirects to order page with a message' do
          patch :update, id: @order.id, code: promotions(:inactive).code
          expect(response).to redirect_to order_path @order
          expect(flash[:alert]).to match 'not active'
          expect(@order.adjustment).to be_nil
        end
      end
      context 'promotion exists' do
        before do
          @promotion = promotions(:welcome)
        end
        context 'order does not have an existing adjustment' do
          before do
            @order = orders(:birds_order_active)
          end
          it 'creates a new adjustment' do
            patch :update, id: @order.id, code: @promotion.code
            expect(flash[:notice]).to match 'has been applied'
            expect(@order.adjustment_amount).to eq 2
            expect(response).to redirect_to order_path @order
          end
          it 'understands a code with wrong case' do
            patch :update, id: @order.id, code: @promotion.code.upcase
            expect(flash[:notice]).to match 'has been applied'
            expect(@order.adjustment_amount).to eq 2
            expect(response).to redirect_to order_path @order
          end
        end
        context 'order has an existing adjustment' do
          before do
            @order = orders(:cards_order)
          end
          context 'the user enters the same code again' do
            it 'does nothing and shows a message' do
              patch :update, id: @order.id, code: 'welcome'
              expect(@order.reload.promotion).to eq promotions(:welcome)
              expect(flash[:notice]).to match 'has already been applied'
              expect(response).to redirect_to order_path @order
            end
          end
          context 'a different code is inserted' do
            before do
              @promotion = promotions(:sale)
            end
            it 'updates the adjustment' do
              expect(@order.promotion).to eq promotions(:welcome)
              expect(@order.adjustment_amount).to eq 1
              patch :update, id: @order.id, code: @promotion.code
              expect(@order.reload.promotion).to eq @promotion
              expect(@order.reload.adjustment_amount).to eq 5
              expect(flash[:notice]).to match 'has been applied'
              expect(response).to redirect_to order_path @order
            end
          end
        end
      end
    end
    context 'guest user' do
      it 'prompts user to log in' do
        patch :update, id: own_order_unfinished.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
