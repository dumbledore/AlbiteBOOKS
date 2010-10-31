class BooksController < MixedController

  def index
#    page = (params[:page]) ? params[:page] : 0
    unless APP_CONFIG['hide_book_index']
      letter = process_letter((params[:id]) ? params[:id] : 'a')
      @books = Book.find(:all, :conditions => "letter = '#{letter}'", :order => :title)
      @letter_name = name_for_letter_number(letter)
      @myurl = books_url
    else
      @books = Book.find(:all, :order => :title)
    end
    render :action => 'index'
  end

  def show
    begin
      @book = Book.find(params[:id], :include => :author)
      @mobile = mobile?
      render :action => 'show'
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

    @book.fill_in_from_freebase if not @book.freebase_uid.empty? and @book.valid?
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

    @book.fill_in_from_freebase if not @book.freebase_uid.empty? and @book.valid?
    if @book.errors.empty? and @book.save
      flash[:notice] = "Successfully updated the book."
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