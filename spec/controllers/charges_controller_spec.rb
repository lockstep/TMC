require 'stripe_mock'

describe ChargesController, type: :controller do
  fixtures :products
  fixtures :orders
  fixtures :line_items
  fixtures :users
  fixtures :charges
  fixtures :adjustments
  fixtures :promotions

  let(:michelle)         { users(:michelle) }
  let(:cards_order)      { orders(:cards_order) }
  let(:unassigned_order) { orders(:unassigned_order) }

  describe '#create' do
    include_context 'before_after_mailer'

    before do
      StripeMock.start
      allow(NotifySlackWorker).to receive(:perform_async)
    end
    after { StripeMock.stop }

    context 'signed in user' do
      before do
        sign_in michelle
      end
      it 'assigns the order to the user' do
        session[:order_id] = unassigned_order.id
        post :create, params: stripe_params
        expect(unassigned_order.reload.user).to eq michelle
      end
      it 'changes order from active to paid' do
        session[:order_id] = unassigned_order.id
        post :create, params: stripe_params
        expect(unassigned_order.reload).to be_paid
      end
      it 'redirects to order success page' do
        session[:order_id] = unassigned_order.id
        post :create, params: stripe_params
        expect(session[:new_order]).to eq true
        expect(response).to redirect_to success_order_path(unassigned_order)
      end
      context 'charges' do
        it 'charges the right amount for simple orders' do
          session[:order_id] = unassigned_order.id
          post :create, params: stripe_params
          charge = Stripe::Charge.all[:data][0][:amount]
          expect(charge).to eq unassigned_order.total*100
        end
        it 'charges the right amount for orders with promotions' do
          session[:order_id] = cards_order.id
          post :create, params: stripe_params
          charge = Stripe::Charge.all[:data][0][:amount]
          expect(charge).to eq cards_order.total*100
        end
      end
      context 'confirmation mailer' do
        before { Sidekiq::Testing.inline!  }
        it 'has no mention of discount for orders with no discount' do
          session[:order_id] = unassigned_order.id
          post :create, params: stripe_params
          expect(ActionMailer::Base.deliveries.count).to eq(1)
          expect(ActionMailer::Base.deliveries.last.encoded)
            .not_to match 'Discount'
        end
        it 'lists discount details for orders with applied discount' do
          session[:order_id] = cards_order.id
          post :create, params: stripe_params
          expect(ActionMailer::Base.deliveries.count).to eq(1)
          email = ActionMailer::Base.deliveries.last.encoded
          expect(email).to match 'Discount'
          expect(email).to match cards_order.promotion_code.upcase
          expect(email).to include "-$#{cards_order.adjustment_total}"
        end
      end
    end

    context 'a failed payment' do
      before do
        StripeMock.prepare_card_error(:card_declined)
        session[:order_id] = cards_order.id
        post :create, params: stripe_params
      end
      it 'redirects back to the cart' do
        expect(response).to redirect_to order_path(cards_order)
      end
      it 'does not send out any emails' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      it 'shows an error flash notice' do
        expect(flash[:error]).to be_present
      end
    end
  end

  def stripe_params
    stripe_helper = StripeMock.create_test_helper

    {
      stripeEmail: michelle.email,
      stripeToken: stripe_helper.generate_card_token
    }
  end
end
