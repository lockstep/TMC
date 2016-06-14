class ApplicationMailer < ActionMailer::Base
  include Devise::Controllers::UrlHelpers
  default from: 'The Montessori Company <support@themontessoricompany.com>',
    reply_to: 'Michelle <michelle@themontessoricompany.com>'
  layout 'mailer'
end
