class SubjectsController < ApplicationController
  def index
    @subjects = Book.tag_counts_on(:subjects)
  end

  def show
    @subject = params[:subject]
    @books = Book.tagged_with(@subject).find(:all, :include => :author, :limit => 32)
    @no_books_message = 'No books in this subject, so far.'
    @show_author_name = true
  end
end