  def mobile_link_to(url, title, subtitle = nil, arrow = true, image = nil, icon = true)
    link = '<div class="text"><div class="hover">'
    link << "<div class=\"icon_#{image}\">" if image and icon

    classes = ''
    if icon or arrow
      classes = []
      classes << 'icon' if image and icon
      classes << 'arrow' if arrow
      classes = ' class="' + classes.join(' ') + '"'
    end

    link << "<a href=\"#{url}\"#{classes}>"
    link << "<table><tr><td><img src=\"#{image}\" class=\"small\" /></td><td>" if image and not icon
    link << "<strong>#{title}</strong>"
    link << "<br /><span class=\"subtitle\">#{subtitle}</span>" if not subtitle.nil? and not subtitle.empty?
    link << '</td></tr></table>' if image and not icon
    link << '</a>'
    link << '</div>' if image and icon
    link << '</div></div>'

    link
  end