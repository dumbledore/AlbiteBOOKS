# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper   
  def title(page_title)
    content_for(:title) {"#{page_title} at "}
  end

  def on_load(pre_func, post_func = nil)
    content_for(:on_load_pre) {"#{pre_func};"}
    content_for(:on_load_post) {"#{post_func};"} if post_func
  end

  def freebase_suggest(search_field, freebase_field, type_info, mql_filer = nil)
    @search_field = search_field
    @freebase_field = freebase_field
    @type_info = type_info
    @mql_filter = mql_filer

    content_for(:head) do
      render :partial => 'misc/freebase_suggest'
    end
  end

  def focus_on_load(form_item)
    content_for(:focus_on_load) {"focus_on_load('#{form_item}');"}
  end

  def user_admin
    current_user and current_user.admin
  end

  def can_add_users
    APP_CONFIG['can_add_users']
  end

  def production?
      @is_production ||= (ENV['RAILS_ENV'] == 'production')
  end

  def mobile_link_to(url, title, subtitle = nil, arrow = true, image = nil, icon = true)
    link = '<div class="text"><div class="hover">'
    link << "<div class=\"icon_#{image}\">" if icon

    classes = ''
    if icon or arrow
      classes = []
      classes << 'icon' if icon
      classes << 'arrow' if arrow
      classes = ' class="' + classes.join(' ') + '"'
    end

    link << "<a href=\"#{url}\"#{classes}>"
    link << "<table><tr><td><img src=\"#{image}\" class=\"small\" /></td><td>" if image and not icon
    link << "<strong>#{title}</strong>"
    link << "<br /><span class=\"subtitle\">#{subtitle}</span>" if not subtitle.nil? and not subtitle.empty?
    link << '</td></tr></table>' if image and not icon
    link << '</a>'
    link << '</div>' if icon
    link << '</div></div>'

    link
  end
end