class BooksController < ApplicationController
  include Lettercode
  before_filter :require_admin, :except => [:index, :show, :search, :latest]

  def new
    begin
      author = Author.find(params[:author], :include => :alias_name)
      @book = author.books.build
      @book.author = author
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Author was not found'
      redirect_to authors_url
    end
  end

  def create
    begin
      @book = Book.new(params[:book])
      @book.author = Author.find(@book.author_id, :include => :alias_name)

      Book.transaction do
        if @book.save
          @book.create_aliases # create additional resources
          flash[:notice] = 'Successfully created book.'
          redirect_to @book
        else
          render :action => 'new'
        end
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Author was not found'
      redirect_to authors_url
    rescue => msg
      puts 'ERROR: ' + msg.inspect;
      flash[:error] = 'Something is wrong with the transaction'
      render :action => 'new'
    end
  end

  def edit
    begin
      @book = Book.find(params[:id], :include => [{:author => :alias_name}])
      @aliases = @book.book_aliases
      @translations = @book.translations
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Book was not found'
      redirect_to books_url
    end
  end

  def update
    begin
      @book = Book.find(params[:id], :include => [{:author => :alias_name}])

      Book.transaction do
        if @book.update_attributes(params[:book])
          flash[:notice] = 'Successfully updated the book.'
          redirect_to @book
        else
          render :action => 'edit'
        end
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Book was not found'
      redirect_to books_url
    rescue => msg
      puts 'ERROR: ' + msg.inspect;
      flash[:error] = 'Something is wrong with the transaction'
      render :action => 'new'
    end
  end

  def destroy
    begin
      @book = Book.find(params[:id])
      @book.destroy
      flash[:notice] = 'Successfully destroyed book.'
      redirect_to author_url @book.author_id
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Book was not found'
      redirect_to books_url
    end
  end


  def index
    unless mobile?
      conditions = nil

      unless APP_CONFIG['hide_book_index']
        letter = process_letter((params[:letter]) ? params[:letter] : 'a')
        conditions = "letter = '#{letter}'"
        @letter_name = name_for_letter_number(letter)
      end

      @book_aliases = BookAlias.paginate(
              :page => params[:page], :per_page => APP_CONFIG['paginate']['index']['html'],
              :conditions => conditions, :order => :title, :include => [{:book => :author}])
      @no_book_aliases_message = 'There are no books with a name that starts with this letter.'
    end
  end


  def show
    begin
      @book = Book.find(params[:id], :include => :author)
      @freebase_item = @book
      @translations = @book.translations
      @disqus = 'book_' + @book.id.to_s
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Book was not found'
      redirect_to books_url
    end
  end

  def search
    @query = params[:query]

    if @query and not @query.empty?
      @book_aliases   = BookAlias.with_query(@query).paginate   :page => params[:page], :per_page => APP_CONFIG['paginate']['search']['html'], :include => [:book, {:book => :author}]
    end

    @book_alias_thumbnails = true
    @no_book_aliases_message = 'No books have been found for this query.'
  end

  def latest
    @books = Book.paginate(:page => params[:page], :per_page => APP_CONFIG['paginate']['latest'][(mobile? ? 'mobile' : 'html')], :order => 'id DESC', :include => :author)
    @book_thumbnails = true
  end
end