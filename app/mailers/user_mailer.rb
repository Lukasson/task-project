class UserMailer < ActionMailer::Base
  default from: "ocs.mailtest1@gmail.com"
  
  def notify_task(user)
    @user = user
    mail(to: user.email, subject: "Task Assignment")
  end
end
