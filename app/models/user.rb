class User < ActiveRecord::Base
  is_gravtastic!

  attr_accessible :password, :password_confirmation, :current_password
  attr_accessor :current_password, :robotic_reset

  validate(:password_check_validation, :on => :update)

  def password_check_validation
    errors[:current_password] << "is incorrect" if not self.robotic_reset and not password.blank? and not self.valid_password? current_password
    errors.add(:current_password, "is incorrect") if not self.robotic_reset and not password.blank? and not self.valid_password? current_password
  end

  acts_as_authentic do |c|
    c.validates_length_of_password_field_options({:in => 6..16, :if => :require_password?})
#    c.maintain_sessions
    c.logged_in_timeout = 1.hour # default is 10.minutes
  end  

  def active?
    active
  end

  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.deliver_activation_instructions(self)
  end

  def deliver_activation_confirmation!
    reset_perishable_token!
    Notifier.deliver_activation_confirmation(self)
  end

  def deliver_password_reset_confirmation!
    reset_perishable_token!
    Notifier.deliver_password_reset_confirmation(self)
  end

  def deliver_new_password!
    reset_perishable_token!
    Notifier.deliver_new_password(self)
  end

  def sign_up!(user, captcha_valid)
    self.username = user[:username]
    self.email = user[:email]
    self.password = user[:password]
    self.password_confirmation = user[:password_confirmation]

    user_valid = self.valid?
    self.errors[:base] << "You didn't write the captcha correctly" if not captcha_valid

    if user_valid && captcha_valid
      save_without_session_maintenance
    else
      false
    end
  end

  def reset_password!
    self.password = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{username}--")[0,10]
    self.password_confirmation = self.password
    save_without_session_maintenance
  end

  def activate!
    self.active = true
    save false
  end
end