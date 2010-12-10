module BooksHelper
  def book_alias_in_list(aliaz, show_thumbnails)
    if aliaz.book.ready or user_admin?
      html = '<table class="list"><tr>'

      if show_thumbnails
        image_url = (aliaz.book.thumbnail_url.blank? ? 'misc/no-book.gif' : h(aliaz.book.thumbnail_url))
        html << '<td>' + image_tag(image_url, :class => 'thumblist') + '</td>'
      end

      html << %[<td><p#{' class="strike"' unless aliaz.book.ready} >]
      html << link_to(h(aliaz.title), book_url(aliaz.book), :class => 'item')
      html << " (<i>#{h(aliaz.book.title)}</i>)" unless aliaz.id == aliaz.book.alias_title_id
      html << %[<br/><span class="by">by #{link_to(h(aliaz.book.author.name), aliaz.book.author, :class => 'item')}</i>]
      html << edit_book_links(aliaz.book) if user_admin?
      html << '</p></td>'
      html << '</tr></table>'
    end
  end

  def book_in_list(book, show_thumbnails, show_author = false)
    if book.ready or user_admin?
      html = '<table class="list"><tr>'

      if show_thumbnails
        image_url = (book.thumbnail_url.blank? ? 'misc/no-book.gif' : h(book.thumbnail_url))
        html << '<td>' + image_tag(image_url, :class => 'thumblist') + '</td>'
      end

      html << %[<td><p#{' class="strike"' unless book.ready} >]
      html << link_to(h(book.title), book_url(book), :class => 'item')
      html << " (<i>#{h(book.date_of_first_publication)}</i>)" unless book.date_of_first_publication.empty?
      html << %[ by #{link_to(book.author.name_cached, book.author, :class => 'item')}] if show_author
      html << edit_book_links(book) if user_admin?
      html << '</p></td>'
      html << '</tr></table>'
    end
  end

  def book_aka(book)
    if @book.book_aliases.size > 1
      aliases = []
      for aliaz in book.book_aliases
        aliases << h(aliaz.title) unless book.alias_title == aliaz
      end
      %[
        <p>
          <strong>Also known as: </strong>
          #{aliases.join(", ")}
        </p>
       ]
    end
  end

  def book_aka_mobile(book)
    if @book.book_aliases.size > 1
      aliases = ''
      for aliaz in book.book_aliases
        aliases << %[<p>#{h(aliaz.title)}</p>] unless book.alias_title == aliaz
      end

      h2('Also known as') + aliases
    end
  end

  def book_tag_list(tag_title, tag_list)
    unless tag_list.empty?
      tags = []
      for tag in tag_list
        tags << link_to(tag, h(yield(tag)), :class => 'item')
      end
      %[
        <p>
          <strong>#{tag_title}:</strong> #{tags.join ", "}
        </p>
       ]
    end
  end

  def book_tag_list_mobile(tag_title, tag_list)
    unless tag_list.empty?
      tags = h2(tag_title)
      for tag in tag_list
        tags << mobile_link_to(h(yield(tag)), h(tag), nil, true, 'tag', true, true)
      end
      tags
    end
  end
end