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
end