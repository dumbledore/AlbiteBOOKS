class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => :new
  before_filter :require_logged_in, :only => :destroy
  
  def new
    session[:restore] = request.referer
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully logged in."
      redirect_to session[:restore]
    else
      @user_session.errors.clear
      @user_session.errors.add_to_base "Invalid username or password or you haven't activated your account yet."
      render :action => 'new'
    end
  end
  
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to :back
  end
end
