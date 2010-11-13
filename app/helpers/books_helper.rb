module BooksHelper
  def book_alias_in_list(aliaz, show_thumbnails)
    if aliaz.book.ready or user_admin
      html = '<table class="list"><tr>'

      if show_thumbnails
        image_url = (aliaz.book.thumbnail_url.blank? ? 'misc/no-image.gif' : aliaz.book.thumbnail_url)
        html << '<td>' + image_tag(image_url, :class => 'thumblist') + '</td>'
      end

      html << %[<td><p#{' class="strike"' unless aliaz.book.ready} >]
      html << link_to(h(aliaz.title), book_url(aliaz.book))
      html << " (<i>#{h(aliaz.book.title)}</i>)" unless aliaz.id == aliaz.book.alias_title_id
      html << %[<br/><span class="by">by #{link_to(h(aliaz.book.author.name), aliaz.book.author)}</i>]

      if user_admin
        html << link_to(image_tag('misc/edit.png'), edit_book_path(aliaz.book))
        html << link_to(image_tag('misc/delete.png'), aliaz.book,
                        :confirm => 'Are you sure you want to delete this book and all its translations?',
                        :method => :delete)
      end

      html << '</p></td>'
      html << '</tr></table>'
    end
  end

  def book_in_list(book, show_thumbnails)
    if book.ready or user_admin
      html = '<table class="list"><tr>'

      if show_thumbnails
        image_url = (book.thumbnail_url.blank? ? 'misc/no-image.gif' : book.thumbnail_url)
        html << '<td>' + image_tag(image_url, :class => 'thumblist') + '</td>'
      end

      html << %[<td><p#{' class="strike"' unless book.ready} >]
      html << link_to(h(book.title), book_url(book))
      html << " (<i>#{h(book.date_of_first_publication)}</i>)" unless book.date_of_first_publication.empty?

      if user_admin
        html << link_to(image_tag('misc/edit.png'), edit_book_path(book))
        html << link_to(image_tag('misc/delete.png'), book,
                        :confirm => 'Are you sure you want to delete this book and all its translations?',
                        :method => :delete)
      end

      html << '</p></td>'
      html << '</tr></table>'
    end
  end

  def book_aka(book)
    aliases = []
    for aliaz in book.book_aliases
      aliases << h(aliaz.title) unless book.alias_title == aliaz
    end
  aliases.join(", ")
  end

  def book_aka_mobile(book)
    aliases = ''
    for aliaz in book.book_aliases
      aliases << %[<p>#{h(aliaz.title)}</p>] unless book.alias_title == aliaz
    end

    aliases
  end
end