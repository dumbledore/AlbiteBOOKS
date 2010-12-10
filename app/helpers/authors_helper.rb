module AuthorsHelper
  def author_alias_in_list(aliaz, show_thumbnails)
    if aliaz.author.ready or user_admin?
      html = '<table class="list"><tr>'

      if show_thumbnails
        image_url = (aliaz.author.thumbnail_url.blank? ? 'misc/no-user.gif' : h(aliaz.author.thumbnail_url))
        html << '<td>' + image_tag(image_url, :class => 'thumblist') + '</td>'
      end

      html << %[<td><p#{' class="strike"' unless aliaz.author.ready} >]
      html << link_to(h(aliaz.name_abbreviated(:name_reversed)), author_url(aliaz.author), :class => 'item')
      html << " (<i>#{h(aliaz.author.name_cached)}</i>)" unless aliaz.id == aliaz.author.alias_name_id
      html << edit_author_links(aliaz.author) if user_admin?
      html << '</p></td>'
      html << '</tr></table>'
    end
  end

  def author_in_list(author, show_thumbnails)
    if author.ready or user_admin?
      html = '<table class="list"><tr>'

      if show_thumbnails
        image_url = (author.thumbnail_url.blank? ? 'misc/no-user.gif' : h(author.thumbnail_url))
        html << '<td>' + image_tag(image_url, :class => 'thumblist') + '</td>'
      end

      html << %[<td><p#{' class="strike"' unless author.ready} >]
      html << link_to(h(author.name_cached), author_url(author), :class => 'item')
      html << edit_author_links(author) if user_admin?
      html << '</p></td>'
      html << '</tr></table>'
    end
  end

  def author_aka(author)
    if @author.author_aliases.size > 1
      aliases = []
      for aliaz in author.author_aliases
        aliases << h(aliaz.name) unless author.alias_name == aliaz
      end
      %[
        <p>
          <strong>Also known as: </strong>
          #{aliases.join(", ")}
        </p>
       ]
    end
  end

  def author_aka_mobile(author)
    if @author.author_aliases.size > 1
      aliases = ''
      for aliaz in author.author_aliases
        aliases << %[<p>#{h(aliaz.name)}</p>] unless author.alias_name == aliaz
      end
      h2('Also known as') + aliases
    end
  end

  def simple_section(section_text, section_name = nil)
    if section_text and not section_text.empty?
      %[
        <p>
          <strong>#{section_name}:</strong>
          #{h(section_text)}
        </p>
       ]
    end
  end

  def simple_section_mobile(section_text, section_name = nil)
    if section_text and not section_text.empty?
      %[
        #{h2(h(section_name)) if section_name}
        <p>
          #{h(section_text)}
        </p>
       ]
    end
  end
end