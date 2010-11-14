class UsersController < ApplicationController
before_filter :require_no_user, :only => [:forgot_password, :activate]
before_filter :require_logged_in, :only => :edit
  
  def new
    @user = User.new
  end
  
  def create
    if APP_CONFIG['can_add_users'] or params[:user][:username] == 'admin'
      @user = User.new

      if @user.sign_up!(params[:user], verify_recaptcha)
        @user.deliver_activation_instructions!
        flash[:notice] = 'Check your e-mail for your account activation instructions.'
        redirect_to root_url
      else
        render :new
      end
    else
      redirect_to root_url 
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update_attributes(params[:user])
      flash[:notice] = 'Successfully updated profile.'
      redirect_to root_url
    else
      render :edit
    end
  end

  def forgot_password
    user_found = false

    unless defined?(params[:user][:email]).nil?
      user_found = true
      @user = User.where({:email => params[:user][:email]})

      if @user.nil? || !@user.active?
        @user = User.new
        @user.errors.add :email, ' not valid or account not yet activated'
        user_found = false
      end

      if not verify_recaptcha
        @user.errors[:base] << "You didn't write the captcha correctly"
        user_found = false
      end
    end

    if user_found
      @user.deliver_password_reset_confirmation!
      flash[:notice] = 'Check your mail to reset your password.'
      redirect_to root_url
    end

    @xurl = 'forgot_password'
    @xmessage = 'Cannot reset your password.'
  end

  def activate
    user_found = false
    unless defined?(params[:user][:email]).nil?
      user_found = true
      @user = User.where({:email => params[:user][:email]})

      if @user.nil?
        @user = User.new
        @user.errors.add :email, ' not valid'
        user_found = false
      end

      if not verify_recaptcha
        @user.errors[:base] << "You didn't write the captcha correctly"
        user_found = false
      end
    end

    if user_found
      @user.deliver_activation_instructions!
      flash[:notice] = 'Check your e-mail for your account activation instructions.'
      redirect_to root_url
    end

    @xurl = 'activate'
    @xmessage = 'Cannot send activation instructions.'
  end
end
