class UserMailer < ApplicationMailer
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
  
    @body[:url]  = "#{APP_CONFIG[:site_url]}/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "#{APP_CONFIG[:site_url]}/"
  end

end
