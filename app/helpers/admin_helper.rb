module AdminHelper
  def new_author_link
    %[<p><b>#{link_to('New author', :controller => 'authors', :action => 'new')}</b></p>] if user_admin
  end

  def new_book_link(author)
    %[<p><b>#{link_to('New book', :controller => 'books', :action => 'new', :author => author)}</b></p>] if user_admin
  end

  def new_translation_link(book)
    %[<p><b>#{link_to 'New translation', :controller => 'translations', :action => 'new', :book => book}</b></p>] if user_admin
  end

  def new_author_alias_link(author)
    %[<p><b>#{link_to 'New alias', :controller => 'author_aliases', :action => 'new', :author => author}</b></p>] if user_admin
  end

  def new_book_alias_link(book)
    %[<p><b>#{link_to 'New alias', :controller => 'book_aliases', :action => 'new', :book => book}</b></p>] if user_admin
  end
end