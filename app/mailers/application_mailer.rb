class ApplicationMailer < ActionMailer::Base
  include Devise::Controllers::UrlHelpers
  default from: 'michelle@themontessoricompany.com'
  layout 'mailer'
end
