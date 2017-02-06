class MailchimpSubscriber
  def initialize
    @mailchimp = Mailchimp::API.new(ENV['MAILCHIMP_API_KEY'])
  end

  # subscribing individual records
  def subscribe(email, list_id = nil)
    list = list_id || ENV['MAILCHIMP_LIST_ID']
    @mailchimp.lists.subscribe(
      list, { email: email }, nil, 'html', false, true, false
    )
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
