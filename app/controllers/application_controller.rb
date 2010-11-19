# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all

  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :home?, :mobile_format

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  layout 'albite'

  # make this methods available in the view
  helper_method :current_user, :user_admin?, :query, :overlay?

  private

  def home?
    @home = controller_name == 'home' && action_name == 'home'
  end

  def overlay?
    @overlay ||= !(!APP_CONFIG['overlay'][true] || APP_CONFIG['overlay']['except'].include?(request.env['REMOTE_ADDR']))
  end

  def mobile?
    @mobile ||= cache_mobile
  end

  def cache_mobile
    return mobile_subdomain? if APP_CONFIG['mobile_by_subdomain']
    mobile_user_agent?
  end

  def mobile_subdomain?
    @mobile_subdomain ||= (request.subdomains.first == 'm')
  end

  def mobile_user_agent?
    @mobile_user_agent ||= cache_mobile_user_agent(request.env)
  end

  def cache_mobile_user_agent(env)
    case env['HTTP_USER_AGENT']
      when /(ipod|iphone)/i then return :iphone
      when /android/i then return :android
      when /opera mini/i then return :opera
      when /blackberry/i then return :blackberry
      when /(palm os|palm|hiptop|avantgo|plucker|xiino|blazer|elaine)/i then return :palm
      when /(windows ce; ppc;|windows ce; smartphone;|windows ce; iemobile)/i then return :windows
      when /(up\.browser|up\.link|mmp|symbian|smartphone|midp|wap|vodafone|o2|pocket|kindle|mobile|pda|psp|treo)/i then return :other
    end

    if env['HTTP_ACCEPT'] =~ /(text\/vnd\.wap\.wml|application\/vnd\.wap\.xhtml\+xml)/
      return :wap_accept
    end

    if (env['HTTP_X_WAP_PROFILE'] && env['HTTP_X_WAP_PROFILE'] != "") || (env['HTTP_PROFILE'] && env['HTTP_PROFILE'] != "")
      return :wap_profile
    end
  end
  
  # User handling methods

  def current_user_session
    @current_user_session ||= UserSession.find
  end

  def current_user
    @current_user ||= current_user_session && current_user_session.record
  end

  def require_no_user
    if current_user
      redirect_to root_url
      false
    end
  end

  def require_logged_in
    redirect_to root_url if not current_user
  end
  
  def require_admin
    redirect_to root_url if not user_admin?
  end

  def user_admin?
    @user_admin ||= current_user and current_user.admin
  end

  def back(url)
    if session[:restore] and not session[:restore].blank?
      session[:restore]
    else
      url
    end
  end

  def mobile_format
    request.format = :mobile if mobile?
  end

  def query
    params[:query]
  end

  # Logging stuff

  EXCEPTIONS_NOT_LOGGED = ['ActionController::UnknownAction', 'ActionController::RoutingError']

  protected
    def log_error(exc)
      super unless EXCEPTIONS_NOT_LOGGED.include?(exc.class.name)
    end
end
