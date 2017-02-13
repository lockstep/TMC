class ApplicationMailer < ActionMailer::Base
  include Devise::Controllers::UrlHelpers
  ADMIN_EMAILS = [
    'Michelle <michelle@themontessoricompany.com>',
    'Paul <paul@locksteplabs.com>'
  ]

  default from: 'The Montessori Company <support@themontessoricompany.com>',
    reply_to: 'Michelle <michelle@themontessoricompany.com>'
  layout 'mailer'
end
