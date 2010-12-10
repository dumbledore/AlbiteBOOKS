class SubjectsController < ApplicationController
  def index
    @subjects = Book.tag_counts_on(:subjects).paginate(
            :page => params[:page], :per_page => APP_CONFIG['paginate']['tags'][(mobile? ? 'mobile' : 'html')])
  end

  def show
    @subject = params[:subject]
    @books = Book.tagged_with(@subject).paginate(
            :page => params[:page], :per_page => APP_CONFIG['paginate']['tags'][(mobile? ? 'mobile' : 'html')],
            :include => :author)
    @no_books_message = 'No books in this subject, so far.'
    @show_author_name = true
  end
end