class HomeController < ApplicationController
  def index
#    @books = Book.includes(:author).order('created_at DESC').limit(300) #TODO, change the limit to a smaller value
    @books = Book.find(:all, :limit => 300, :order => 'created_at DESC', :include => :author)
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
      @results = []
    else
      @query = params[:query]
      begin
      search = Book.find_with_index(@query, {:limit => 10}, {:ids_only => true})
      @results = Book.find(search, :order => :title, :include => :author)
      rescue
        @results = []
      end
    end
  end
end