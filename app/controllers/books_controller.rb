class BooksController < ApplicationController
  before_filter :require_admin, :only => ['new', 'create', 'edit', 'update', 'destroy']

  def index
# TODO: not done here!   
    @author = Author.find(params[:author_id])
    @books = @author.books
  end

  def show
    begin
      @book = Book.find(params[:id], :include => :author)
      @mobile = mobile?
    rescue ActiveRecord::RecordNotFound
      redirect_to books_url
    end
  end
  
  def new
    begin
      author = Author.find(params[:author], :include => :alias_name)
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Author was not found'
      redirect_to authors_url
    end
    @book = author.books.build
    @book.author = author
  end

  def create
    begin
      @book = Book.new(params[:book])
      @book.author = Author.find(@book.author_id, :include => :alias_name)
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Author was not found'
      redirect_to authors_url
    end

    #Setup the tags
    @book.genre_list = params[:book][:genre_list]
    @book.subject_list = params[:book][:subject_list]

    @book.fill_in_from_freebase unless @book.freebase_uid.empty?
    if @book.errors.empty? and @book.save
      flash[:notice] = 'Successfully created book.'
      redirect_to @book
    else
      render :action => 'new'
    end
  end
  
  def edit
    begin
      @book = Book.find(params[:id], :include => [{:author => :alias_name}])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Book was not found'
      redirect_to books_url
    end
  end

  def update
    begin
      @book = Book.find(params[:id], :include => [{:author => :alias_name}])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Book was not found'
      redirect_to books_url
    end

    #Setup the tags
    @book.genre_list = params[:book][:genre_list]
    @book.subject_list = params[:book][:subject_list]

    @book.fill_in_from_freebase unless @book.freebase_uid.empty?
    if @book.errors.empty? and @book.update_attributes(params[:book])
      flash[:notice] = "Successfully updated book."
      redirect_to @book
    else
      render :action => 'edit'
    end
  end

  def destroy
    begin
      @book = Book.find(params[:id])
      @book.destroy
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Book was not found'
      redirect_to books_url
    end

    flash[:notice] = "Successfully destroyed book."
    redirect_to edit_author_url @book.author_id
  end
end