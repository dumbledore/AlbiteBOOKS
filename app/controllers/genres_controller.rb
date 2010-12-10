class GenresController < ApplicationController
  def index
    @genres = Book.tag_counts_on(:genres).paginate(
            :page => params[:page], :per_page => APP_CONFIG['paginate']['tags'][(mobile? ? 'mobile' : 'html')])
  end

  def show
    @genre = params[:genre]
    @books = Book.tagged_with(@genre).paginate(
            :page => params[:page], :per_page => APP_CONFIG['paginate']['tags'][(mobile? ? 'mobile' : 'html')],
            :include => :author)
    @no_books_message = 'No books in this genre, so far.'
    @show_author_name = true
  end
end