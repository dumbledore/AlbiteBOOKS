class HomeController < ApplicationController
  def home
    unless mobile?
      @books = Book.find(:all, :limit => APP_CONFIG['homepage_book_count'], :order => 'created_at DESC', :include => :author)
    end
  end

  def genres
    unless @mobile
      @genres = Book.tag_counts_on(:genres)
    else
      redirect_to root_url
    end
  end

  def genre
    @genre = params[:genre]
    @books = Book.tagged_with(@genre)
  end

  def subjects
    unless @mobile
      @subjects = Book.tag_counts_on(:subjects)
    else
      redirect_to root_url
    end
  end

  def subject
    @subject = params[:subject]
    @books = Book.tagged_with(@subject)
  end

  def search
    if (params[:query].nil? or params[:query].empty?)
      @query = ''
      @book_aliases   = []
      @author_aliases = []
    else
      @query = params[:query]
      
      begin
        @book_aliases = BookAlias.with_query(@query).find(:all, :limit => 32, :order => :title, :include => [{:book => :author}])
      rescue
        @book_aliases = []
      end

      begin
        @author_aliases = AuthorAlias.with_query(@query).find(:all, :limit => 32, :include => :author, :order => :name_reversed)
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