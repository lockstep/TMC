require "rails_helper"

RSpec.describe ChargesMailer, type: :mailer do
  include_context 'before_after_mailer'
  fixtures :users
  fixtures :orders
  fixtures :charges
  fixtures :line_items

  let(:michelle)      { users(:michelle) }
  let(:cards_order)   { orders(:cards_order) }
  let(:cards_charge)  { charges(:cards_charge) }

  describe '.confirmed_charge' do
    before { ChargesMailer.confirmed_charge(cards_charge.id).deliver_now }

    it_behaves_like "sending_email" do
      let(:sender)     { ['noreply@tmc.com'] }
      let(:recipients) { [ cards_charge.email] }
      let(:subject)    { "Confirmed Payment##{cards_charge.id}" }
    end
  end
end
