module AuthorsHelper
  def author_in_list(aliaz, show_thumbnails)
    if aliaz.author.ready or user_admin?
      html = '<table class="list"><tr>'

      if show_thumbnails
        image_url = (aliaz.author.thumbnail_url.blank? ? 'misc/no-image.gif' : h(aliaz.author.thumbnail_url))
        html << '<td>' + image_tag(image_url, :class => 'thumblist') + '</td>'
      end
      
      html << %[<td><p#{' class="strike"' unless aliaz.author.ready} >]
      html << link_to(h(aliaz.name_abbreviated(:name_reversed)), author_url(aliaz.author))
      html << " (<i>#{h(aliaz.author.name_cached)}</i>)" unless aliaz.id == aliaz.author.alias_name_id
      html << edit_author_links(aliaz.author) if user_admin?
      html << '</p></td>'
      html << '</tr></table>'
    end
  end

  def author_aka(author)
    aliases = []
    for aliaz in author.author_aliases
      aliases << h(aliaz.name) unless author.alias_name == aliaz
    end
    aliases.join(", ")
  end

  def author_aka_mobile(author)
    aliases = ''
    for aliaz in author.author_aliases
      aliases << %[<p>#{h(aliaz.name)}</p>] unless author.alias_name == aliaz
    end
    aliases
  end
end