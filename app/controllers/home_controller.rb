class HomeController < ApplicationController
  def home
    unless mobile?
#      @books = Book.find(:all, :limit => APP_CONFIG['homepage_book_count'], :order => 'created_at DESC', :include => :author)
      @books = Book.random(:author, APP_CONFIG['homepage_book_count'])
    end
  end

  def reader
    @version = '2.0.10'
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
  end

  def search_form
    redirect_to search_url params[:query]
  end

  def thanks
    @disqus = 'thanks'
  end

  def redirect
    redirect_to root_url
  end
end