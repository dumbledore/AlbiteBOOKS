class ActivationsController < ApplicationController
  before_filter :require_no_user, #, :only => [:new, :create]

  def activate
    begin
      @user = User.find_using_perishable_token(params[:activation_code], 1.week)
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Your ticket has expired. Go <a href=\"#{activate_user_url}\">here</a> get a new one."
      redirect_to root_url
      return
    end

    if @user.nil?
      flash[:error] = "Your ticket has expired. Go <a href=\"#{activate_user_url}\">here</a> get a new one."
      redirect_to root_url
      return
    end

    if @user.active?
      flash[:error] = "Your account is already activated."
      redirect_to root_url
      return
    end

    if @user.activate!
      @user.deliver_activation_confirmation!
      flash[:notice] = "Your account has been activated."
    else
      flash[:error] = "Your account could not be activated."
    end
    redirect_to root_url
  end


  def reset_password
    begin
      @user = User.find_using_perishable_token(params[:reset_code], 1.week)
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Your ticket has expired. Go <a href=\"#{forgot_password_url}\">here</a> get a new one."
      redirect_to root_url
      return
    end

    if @user.nil?
      flash[:error] = "Your ticket has expired. Go <a href=\"#{forgot_password_url}\">here</a> get a new one."
      redirect_to root_url
      return
    end

    if not @user.active?
      flash[:error] = "Your account is not activated, yet. Go <a href=\"#{activate_user_url}\">here</a> to activate it."
      redirect_to root_url
      return
    end

    @user.robotic_reset = true
    if @user.reset_password!
      @user.deliver_new_password!
      flash[:notice] = "Your new password was sent to your email."
    else
      flash[:error] = "Could not reset your password."
    end
    redirect_to root_url
  end
end