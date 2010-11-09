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
      @books = []
      @aliases = []
    else
      @query = params[:query]
      
      begin
        search = Book.find_with_index(@query, {:limit => 32}, {:ids_only => true})
        @books = Book.find(search, :order => :title, :include => :author)
      rescue
        @books = []
      end

      begin
        search = Alias.find_with_index(@query, {:limit => 32}, {:ids_only => true})
        @aliases = Alias.find(search, :include => :author, :order => :name_reversed)
      rescue
        @aliases = []
      end

      render 'search.html.erb'
    end
  end
end