class PasswordMailer < ApplicationMailer
  def forgot_password(password)
    setup_email(password.user)
    @subject << 'You have requested to change your password'
    @body[:url] = "#{APP_CONFIG[:site_url]}/change_password/#{password.reset_code}"
  end
 
  def reset_password(user)
    setup_email(user)
    @subject << 'Your password has been reset.'
  end

end
