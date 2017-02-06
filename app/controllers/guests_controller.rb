class GuestsController < ApplicationController

  def join_newsletter
    if params[:email_address].blank?
      redirect_to :back,
        alert: 'Oops, we will need a valid email address to add you to the list.'
    else
      MailchimpSubscriberWorker.perform_async(params[:email_address])
      redirect_to :back,
        notice: 'Thank you for subscribing and joining our Montessori community!'
    end
  end

end
