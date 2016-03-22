class Charge < ActiveRecord::Base
  belongs_to :order

  after_create :send_confirmed_emails

  def send_confirmed_emails
    send_charge_confirmation
    send_order_confirmation
  end

  def send_order_confirmation
    OrdersMailer.confirmed_order(order.id).deliver_now
  end

  def send_charge_confirmation
    ChargesMailer.confirmed_charge(id).deliver_now
  end
end
