module AuthorsHelper
  def author_in_list(aliaz, show_thumbnails)
    if aliaz.author.ready or user_admin
      html = '<table class="list"><tr>'

      if show_thumbnails
        image_url = (aliaz.author.thumbnail_url.blank? ? 'misc/no-image.gif' : aliaz.author.thumbnail_url)
        html << '<td>' + image_tag(image_url, :class => 'thumblist') + '</td>'
      end
      
      html << %[<td><p#{' class="strike"' unless aliaz.author.ready} >]
      html << link_to(aliaz.name_abbreviated(:name_reversed), author_url(aliaz.author))
      html << " (<i>#{h(aliaz.author.name_cached)}</i>)".html_safe unless aliaz.id == aliaz.author.alias_name_id

      if user_admin
        html << link_to(image_tag('misc/edit.png'), edit_author_path(aliaz.author))
        html << link_to(image_tag('misc/delete.png'), aliaz.author,
                        :confirm => 'Are you sure you want to delete this author and their books and translations?',
                        :method => :delete)
      end

      html << '</p></td>'
      html << '</tr></table>'
    end
  end
end