class TranslationsController < ApplicationController
  before_filter :require_admin, :except => [:show]

  def new
    begin
      book = Book.find(params[:book])
      @translation = book.translations.build
      @translation.book = book
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Book was not found'
      redirect_to books_url
    end
  end
  
  def create
    begin
      @translation = Translation.new(params[:translation])
      @translation.book = Book.find(@translation.book_id)

      if @translation.save
        flash[:notice] = "Successfully created translation."
        redirect_to @translation.book
      else
        render :action => 'new'
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Book was not found'
      redirect_to books_url
    end
  end

  def edit
    begin
      @translation = Translation.find(params[:id], :include => :book)
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Translation was not found'
      redirect_to books_url
    end
  end

  def update
    begin
      @translation = Translation.find(params[:id], :include => :book)
      if @translation.update_attributes(params[:translation])
        flash[:notice] = 'Successfully updated translation.'
        redirect_to @translation.book
      else
        render :action => :edit
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Translation was not found'
      redirect_to books_url
    end
  end
  
  def destroy
    begin
      @translation = Translation.find(params[:id])
      @translation.destroy
      redirect_to book_url(@translation.book_id)
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Translation was not found'
      redirect_to books_url
    end
  end

  def show
    begin
      @translation = Translation.find(params[:id], :include => :book)
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Translation was not found'
      redirect_to root_url
    end
  end
end