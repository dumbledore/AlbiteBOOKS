class HomeController < ApplicationController
  def home
    unless mobile?
      @books = Book.find(:all, :limit => APP_CONFIG['homepage_book_count'], :order => 'created_at DESC', :include => :author)
    end
  end

  def latest
#    @books = Book.find(:all, :limit => '', :order => 'created_at DESC', :include => :author)
    @books = Book.paginate(:page => params[:page], :size => APP_CONFIG['paginate'][(mobile? ? 'mobile' : 'html')]).find(:all, :order => :title, :include => [{:book => :author}])
  end

  def genres
    @genres = Book.tag_counts_on(:genres)
  end

  def genre
    @genre = params[:genre]
    @books = Book.tagged_with(@genre).find(:all, :include => :author, :limit => 32)
    @no_books_message = 'No books in this genre, so far.'
    @show_author_name = true
  end

  def subjects
    @subjects = Book.tag_counts_on(:subjects)
  end

  def subject
    @subject = params[:subject]
    @books = Book.tagged_with(@subject).find(:all, :include => :author, :limit => 32)
    @no_books_message = 'No books in this subject, so far.'
    @show_author_name = true
  end

  def search
    @book_aliases   = []
    @author_aliases = []

    if (params[:query].nil? or params[:query].empty?)
      @query = ''
    else
      @query = params[:query]
      
      begin
        @book_aliases = BookAlias.with_query(@query).paginate(:page => params[:page], :per_page => 2, :include => [:book, {:book => :author}])
      rescue
        @book_aliases = []
      end

      begin
#        @author_aliases = AuthorAlias.with_query(@query).find(:all, :limit => 32, :include => :author, :order => :name_reversed)
#        @author_aliases = AuthorAlias.with_query(@query).paginate(:page => params[:page], :size => APP_CONFIG['paginate']['html']).find(:all, :order => :name_reversed, :include => :author)
      rescue
        @author_aliases = []
      end
    end

    @book_alias_thumbnails = true
    @no_book_aliases_message = 'No books have been found for this query.'

    @author_alias_thumbnails = true
    @no_author_aliases_message = 'No authors have been found for this query.'
    
    render 'search.html.erb'
  end
end