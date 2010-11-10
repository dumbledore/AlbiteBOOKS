class BookAliasesController < ApplicationController
  before_filter :require_admin

  def new
    begin
      @book = Book.find(params[:book])
    rescue ActiveRecord::RecordNotFound
      redirect_to books_path
      return
    end
    @alias = @book.book_aliases.build
  end

  def create
    @alias = BookAlias.new(params[:book_alias])
    if @alias.save
      flash[:notice] = "Successfully created alias."
      redirect_to edit_book_path(@alias.book_id)
    else
      flash[:error] = "Couldn't create alias."
      render :action => 'new'
    end
  end

  def edit
    @alias = BookAlias.find(params[:id], :include => :book)
    @book = @alias.book
  end

  def update
    @alias = BookAlias.find(params[:id], :include => :book)
    @book = @alias.book

    if @alias.update_attributes(params[:book_alias])
      flash[:notice] = "Successfully updated alias."
      redirect_to edit_book_url(@alias.book_id)
    else
      flash[:error] = "Couldn't update alias."
      render :action => 'edit'
    end
  end

  def destroy
    @alias = BookAlias.find(params[:id])

    if @alias == @alias.book.alias_title
      flash[:error] = "Titles are not allowed to be destroyed."
    else
      @alias.destroy
    end

    redirect_to edit_book_url(@alias.book_id)
  end

end
