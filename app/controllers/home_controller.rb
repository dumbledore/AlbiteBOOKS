class HomeController < ApplicationController
  def home
    unless mobile?
      @books = Book.find(:all, :limit => APP_CONFIG['homepage_book_count'], :order => 'created_at DESC', :include => :author)
    end
  end

def search
    @query = params[:query]
    
    if @query and not @query.empty?
      @query = params[:query]
      
      @book_aliases   = BookAlias.with_query(@query).paginate   :page => 1, :per_page => APP_CONFIG['paginate']['search']['html'], :include => [:book, {:book => :author}]
      @author_aliases = AuthorAlias.with_query(@query).paginate :page => 1, :per_page => APP_CONFIG['paginate']['search']['html'], :order => :name_reversed, :include => :author
    end

    @book_alias_thumbnails = true
    @no_book_aliases_message = 'No books have been found for this query.'

    @author_alias_thumbnails = true
    @no_author_aliases_message = 'No authors have been found for this query.'
    
    render 'search.html.erb'
  end
end