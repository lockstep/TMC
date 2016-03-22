class ChargesMailer < ApplicationMailer
  def confirmed_charge(charge_id)
    @charge = Charge.find(charge_id)
    mail(to: @charge.email, subject: "Confirmed Payment##{@charge.id}")
  end
end
