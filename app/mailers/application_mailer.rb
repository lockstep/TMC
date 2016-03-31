class ApplicationMailer < ActionMailer::Base
  include Devise::Controllers::UrlHelpers
  default from: 'hello@themontessoricompany.com'
  layout 'mailer'
end
