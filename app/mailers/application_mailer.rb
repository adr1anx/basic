class ApplicationMailer < ActionMailer::Base
  #self.template_root = File.join(RAILS_ROOT, 'app', 'emails', 'views')
  
  protected
  
  def setup_email(user)
    @recipients = "#{user.email}"
    @from = APP_CONFIG[:admin_email]
    @subject = "[#{APP_CONFIG[:site_name]}] "
    @sent_on = Time.now
    @body[:user] = user
  end

end
