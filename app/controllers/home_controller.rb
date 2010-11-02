class HomeController < ApplicationController
  def index
#    @books = Book.includes(:author).order('created_at DESC').limit(300) #TODO, change the limit to a smaller value
    @books = Book.find(:all, :limit => APP_CONFIG['homepage_book_count'], :order => 'created_at DESC', :include => :author)
  end

  def genres
    @genres = Book.tag_counts_on(:genres)
  end

  def genre
    @genre = params[:genre]
    @books = Book.tagged_with(@genre)
  end

  def subjects
    @subjects = Book.tag_counts_on(:subjects)
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
      search = Book.find_with_index(@query, {:limit => 16}, {:ids_only => true})
      @books = Book.find(search, :order => :title, :include => :author)
      rescue
        @books = []
      end

      begin
      search = Alias.find_with_index(@query, {:limit => 16}, {:ids_only => true})
      @aliases = Alias.find(search, :include => :author, :order => :name_reversed)
      rescue
        @aliases = []
      end
    end
  end
end