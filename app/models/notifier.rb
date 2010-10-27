class Notifier < ActionMailer::Base
  
  def no_reply
    "galileostudios@gmail.com"
  end
    
  def activation_instructions(user)
    subject       "Activation Confirmation at Albite.org"
#    from          :no_reply
    from          'albite.book@gmail.com'
    recipients    user.email
    sent_on       Time.now
    body          :account_info => {:url => activate_url(user.perishable_token), :name => user.username}
  end

  def activation_confirmation(user)
    subject       "Activation Complete"
    from          :no_reply
    recipients    user.email
    sent_on       Time.now
    body          :root_url => root_url
  end

  def password_reset_confirmation(user)
    subject       "Password Recovery"
    from          :no_reply
    recipients    user.email
    sent_on       Time.now
    body          :account_info => {:url => reset_password_url(user.perishable_token), :name => user.username}
  end

  def new_password(user)
    subject       "Your new passward"
    from          :no_reply
    recipients    user.email
    sent_on       Time.now
    body          :account_info => {:root_url => root_url, :name=> user.username, :password => user.password}
  end
end
