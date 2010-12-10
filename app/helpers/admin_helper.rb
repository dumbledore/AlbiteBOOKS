module AdminHelper
  def new_author_link
    %[<p><b>#{link_to('New author</i>', {:controller => 'authors', :action => 'new'}, :accesskey => 'a', :title => 'ALT + A')}</b></p>] if user_admin?
  end

  def new_book_link(author)
    %[<p><b>#{link_to('New book', {:controller => 'books', :action => 'new', :author => author}, :accesskey => 'b', :title => 'ALT + B')}</b></p>] if user_admin?
  end

  def new_translation_link(book)
    %[<p><b>#{link_to('New translation', {:controller => 'translations', :action => 'new', :book => book}, :accesskey => 't', :title => 'ALT + T')}</b></p>] if user_admin?
  end

  def new_author_alias_link(author)
    %[<p><b>#{link_to 'New alias', :controller => 'author_aliases', :action => 'new', :author => author}</b></p>] if user_admin?
  end

  def new_book_alias_link(book)
    %[<p><b>#{link_to 'New alias', :controller => 'book_aliases', :action => 'new', :book => book}</b></p>] if user_admin?
  end

  # --------------------------

  def edit_author_links(author)
    if user_admin?
      link_to(image_tag('misc/edit.png'), edit_author_path(author)) +
      link_to(image_tag('misc/delete.png'), author,
                      :confirm => 'Are you sure you want to delete this author and their books and translations?',
                      :method => :delete)
    end
  end

  def edit_book_links(book)
    if user_admin?
      link_to(image_tag('misc/edit.png'), edit_book_path(book)) +
      link_to(image_tag('misc/delete.png'), book,
                      :confirm => 'Are you sure you want to delete this book and all its translations?',
                      :method => :delete)
    end
  end

  def edit_translation_links(translation)
    if user_admin?
      link_to(image_tag('misc/edit.png'), edit_translation_url(translation)) +
      link_to(image_tag('misc/delete.png'), translation,
                :confirm => 'Are you sure you want to delete this translation?', :method => :delete)
    end
  end

  def edit_author_alias_links(aliaz)
    if user_admin?
      link_to(image_tag('misc/edit.png'), edit_author_alias_path(aliaz)) +
      link_to(image_tag('misc/delete.png'), aliaz, :confirm => 'Are you sure you want to delete this alias?',
                                                   :method => :delete)
    end
  end

  def edit_book_alias_links(aliaz)
    if user_admin?
      link_to(image_tag('misc/edit.png'), edit_book_alias_url(aliaz)) +
      link_to(image_tag('misc/delete.png'), aliaz, :confirm => 'Are you sure you want to delete this alias?',
                                                    :method => :delete)
    end
  end
end