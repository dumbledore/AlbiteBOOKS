class HomeController < ApplicationController
  def home
    unless mobile?
#      @books = Book.find(:all, :limit => APP_CONFIG['homepage_book_count'], :order => 'created_at DESC', :include => :author)
      @books = Book.random(:author, APP_CONFIG['homepage_book_count'])
    end
  end

  def reader
    @version = '2.0.12'
  end

  def search
    @query = params[:query]

      if @query and not @query.empty?
        @query = params[:query]

        book_ids = BookAlias.with_query(@query).find(:all,:select=>'book_id').map {|x| x.book_id}.uniq
        @books = Book.find(book_ids).paginate(
          :page => params[:page], :per_page => APP_CONFIG['paginate']['search']['html'],
          :include => {:book => :author}
        ) if book_ids

        author_ids = AuthorAlias.with_query(@query).find(:all,:select=>'author_id').map {|x| x.author_id}.uniq
        @authors = Author.find(author_ids).paginate(
          :page => params[:page], :per_page => APP_CONFIG['paginate']['search']['html'],
          :order => :name_cached
        ) if author_ids
      end

      @book_thumbnails = true
      @book_authors = true
      @no_books_message = 'No books have been found for this query.'

      @author_thumbnails = true
      @no_authors_message = 'No authors have been found for this query.'
  end

  def search_form
    if params[:query]
      redirect_to search_url params[:query]
    else
      render :search
    end
  end

  def thanks
    @disqus = 'thanks'
  end

  def redirect
    redirect_to root_url
  end
end