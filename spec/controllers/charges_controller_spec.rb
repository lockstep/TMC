require 'stripe_mock'

describe ChargesController, type: :controller do
  fixtures :products
  fixtures :orders
  fixtures :line_items
  fixtures :users
  fixtures :charges

  let(:michelle)         { users(:michelle) }
  let(:cards_order)      { orders(:cards_order) }
  let(:unassigned_order) { orders(:unassigned_order) }

  describe '#create' do
    include_context 'before_after_mailer'

    before { StripeMock.start }
    after { StripeMock.stop }

    context 'completed order' do
      before do
        post :create, order_id: cards_order.id, params: stripe_params
      end
      it 'changes order from active to paid' do
        expect(Order.find(cards_order.id)).to be_paid
      end
      it 'redirects to order success page' do
        expect(response).to redirect_to success_order_path(cards_order)
      end
      it 'charges the right amount' do
        charge = Stripe::Charge.all[:data][0][:amount]
        expect(charge).to eq cards_order.total_price*100
      end
      it 'sends out a confirmation email' do
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end
      context 'signed in user' do
        before do
          sign_in michelle
          post :create, order_id: unassigned_order.id, params: stripe_params
        end
        it 'assigns the order to the user' do
          expect(unassigned_order.reload.user).to eq michelle
        end
      end
    end

    context 'a failed payment' do
      before do
        StripeMock.prepare_card_error(:card_declined)
        post :create, order_id: cards_order.id, params: stripe_params
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
