class MailchimpSubscriber
  def initialize
    @mailchimp = Mailchimp::API.new(ENV['MAILCHIMP_API_KEY'])
  end

  # subscribing individual records
  def subscribe(user)
    # subscribe(id, email, merge_vars = nil, email_type = 'html',
    #   double_optin = true, update_existing = false,
    #   replace_interests = true, send_welcome = false)
    @mailchimp.lists.subscribe(ENV['MAILCHIMP_LIST_ID'], { email: user.email },
                               nil, 'html', false, true, false)
  end

  # this can handle 5k - 10k records at once
  def batch_subscribe(users)
    batch = users.map do |user|
      {
        email: { email: user.email },
        email_type: 'html',
        merge_vars: nil
      }
    end

    @mailchimp.lists.batch_subscribe(ENV['MAILCHIMP_LIST_ID'],
                                     batch, false, true, false)
  end
end
