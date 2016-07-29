class NotifySlackWorker
  include Sidekiq::Worker

  def perform(charge_id)
    charge = Charge.find(charge_id)
    notifier = Slack::Notifier.new(
      ENV.fetch('SLACK_WEBHOOK_URL'),
      channel: '#tmc',
      username: 'cashbot'
    )

    text = "<!channel>\t :tada::tada::tada:  *New order!*  :tada::tada::tada:"
    attachment = {
      "title": "Order #{charge.order_id}",
      "title_link": url_helpers.admin_order_url(charge.order_id),
      "fallback": "We have a new order!",
      "color": "#578BB7",
      "fields": [
        {
          "title": "Order total",
          "value": view_helpers.number_to_currency(charge.amount/100.0),
          "short": false
        },
        {
          "title": "Sales this month",
          "value": view_helpers.number_to_currency(Charge.monthly_sales/100.0),
          "short": true
        },
        {
          "title": "Total sales",
          "value": view_helpers.number_to_currency(Charge.total_sales/100.0),
          "short": true
        }
      ],
      "thumb_url": "https://s3.amazonaws.com/lockstep-public-assets/tmc/slack_thumb_icon.png",
      "footer_icon": "https://s3.amazonaws.com/lockstep-public-assets/tmc/slack_footer_icon.png",
      "ts": Time.now.to_i
    }

    notifier.ping(text, icon_emoji: ":thug_paul:", attachments: [attachment])
  end

  private

  def url_helpers
    Rails.application.routes.url_helpers
  end

  def view_helpers
    ActionController::Base.helpers
  end
end
