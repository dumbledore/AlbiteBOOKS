class GenresController < ApplicationController
  def index
    @genres = Book.tag_counts_on(:genres)
  end

  def show
    @genre = params[:genre]
    @books = Book.tagged_with(@genre).find(:all, :include => :author, :limit => 32)
    @no_books_message = 'No books in this genre, so far.'
    @show_author_name = true
  end
end