class ApplicationMailer < ActionMailer::Base
  include Devise::Controllers::UrlHelpers
  default from: 'The Montessori Company <michelle@themontessoricompany.com>'
  layout 'mailer'
end
