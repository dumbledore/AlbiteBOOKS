module MobileHelper

  def mobile_link_to(url, title, subtitle = nil, arrow = true, image = nil, icon = true, item = false)

    classes = ''
    if icon or arrow or item
      classes = []
      classes << 'icon' if image and icon
      classes << 'arrow' if arrow
      classes << 'item' if item
      classes = ' class="' + classes.join(' ') + '"'
    end

    %[
      <div class="text"><div class="hover">
      #{%[<div class="icon_#{image}">] if image and icon}
      <a href="#{url}"#{classes}>
      #{%[<table><tr class="link"><td><img src="#{image}" class="small" /></td><td>] if image and not icon}
      <strong>#{title}</strong>
      #{%[<br /><span class="subtitle">#{subtitle}</span>] if not subtitle.nil? and not subtitle.empty?}
      #{'</td></tr></table>' if image and not icon}
      </a>
      #{'</div>' if image and icon}
      </div></div>
    ]
  end

  def shadow
    '<div class="shadow_container"><div class="shadow"></div></div>'
  end


  def h1(content)
    heading_tag('1', content)
  end

  def h2(content)
    heading_tag('2', content)
  end

  # According to this Ticket, using form_tag with a block in a helper-method is broken in rails 2.1.
  # http://blog.opensteam.net/past/2008/7/24/form_tag_block_in_a_helpermethod/
  def mobile_search_form(url)
    %[
      <form action="#{url}" method="get">
        <div class="search_bg">
          <table class="search">
            <tr class="search">
              <td>
                <div class="box">
                  <div class="box_left"></div>
                  <div class="box_right"></div>
                </div>
                #{text_field_tag :query, nil, :class => 'box'}
              </td>
              <td class="separator"></td>
              <td class="search">
                <button type="submit" class="go"></button>
              </td>
            </tr>
          </table>
        </div>
        #{shadow}
      </form>
    ]
  end

  def subtitle(*opts)
    subtitle = []

    opts.each do |o|
      subtitle << o if o and not o.empty?
    end

    subtitle = subtitle.join('<br />')
    subtitle = nil if subtitle.empty?

    subtitle
  end

  def book_subtitle(book, show_author_name = false, show_publication_date = false)
    author_name = (show_author_name ? 'by ' + book.author.name : '')
    publication_date = (show_publication_date ? book.date_of_first_publication : '')
    subtitle(author_name, publication_date)
  end

  def mobile_link_to_thumbnail_or_icon(url, title, subtitle, thumbnail_url, icon, item = false)
    if thumbnail_url.blank?
      mobile_link_to(url, title, subtitle, true, icon, true, item)
    else
      mobile_link_to(url, title, subtitle, true, thumbnail_url, false, item)
    end
  end

  private
          
  def heading_tag(level, content)

    section_tag =
    %[
      <h#{level}>
        #{content}
      </h#{level}>
      #{shadow}
    ]
  end
end