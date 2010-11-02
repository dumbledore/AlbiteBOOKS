# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  layout :choose_layout
  
  helper_method :current_user

  private

  def choose_layout
    return 'mobile' if mobile?
    'standard'
  end


  def mobile?
    @mobile ||= cache_mobile(request)
  end

  def cache_mobile(request)
    return mobile_by_subdomain(request) if APP_CONFIG['mobile_by_subdomain']
    mobile_by_user_agent(request.env)
  end

  def mobile_by_subdomain(request)
    request.subdomains.first == 'm'
  end

  def mobile_by_user_agent(env)
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
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_no_user
    if current_user
      redirect_to root_url
      false
    end
  end

  def require_logged_in
    if not current_user
      redirect_to root_url
    end
  end
  
  def require_admin
    if not current_user or not current_user.admin
      redirect_to root_url
    end
  end

  def user_admin
    current_user and current_user.admin
  end

  def back(url)
    if session[:restore] and not session[:restore].blank?
      session[:restore]
    else
      url
    end
  end
end
