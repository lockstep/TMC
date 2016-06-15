class DeviseMailerPreview < ActionMailer::Preview
  def confirmation_instructions
    Devise::Mailer.confirmation_instructions(User.last, 12345678)
  end

  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(User.last, 12345678)
  end

  def password_change
    Devise::Mailer.password_change(User.last)
  end
end
