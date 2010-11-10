class BooksController < ApplicationController
  before_filter :require_admin, :except => [:index, :show]
  
  require 'lib/lettercode.rb'
  include Lettercode
  
  def index
    unless @mobile
      unless APP_CONFIG['hide_book_index']
        letter = process_letter((params[:letter]) ? params[:letter] : 'a')
        @book_aliases = BookAlias.find(:all, :include => [{:book => :author}], :conditions => "letter = '#{letter}'", :order => :title)
        @letter_name = name_for_letter_number(letter)
      else
        @book_aliases = BookAlias.find(:all, :include => [{:book => :author}], :order => :title)
      end

      @book_alias_thumbnails = false
      @no_book_aliases_message = 'There are no books, whose family name starts with this letter.'
    else
      redirect_to root_url
    end
  end

  def show
    begin
      @book = Book.find(params[:id], :include => :author)
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
      return
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
      return
    end

    begin
      Book.transaction do
        if @book.save
          @book.create_aliases # create additional resources
          flash[:notice] = 'Successfully created book.'
          redirect_to @book
        else
          render :action => 'new'
        end
      end
    rescue => msg
      puts "ERROR: " + msg.inspect;
      flash[:error] = "Something is wrong with the transaction"
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
      return
    end

    begin
      Book.transaction do
        if @book.update_attributes(params[:book])
          flash[:notice] = "Successfully updated the book."
          redirect_to @book
        else
          render :action => 'edit'
        end
      end
    rescue => msg
      puts "ERROR: " + msg.inspect;
      flash[:error] = "Something is wrong with the transaction"
      render :action => 'new'
    end
  end

  def destroy
    begin
      @book = Book.find(params[:id])
      @book.destroy
      flash[:notice] = "Successfully destroyed book."
      redirect_to edit_author_url @book.author_id
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Book was not found'
      redirect_to books_url
    end
  end
end