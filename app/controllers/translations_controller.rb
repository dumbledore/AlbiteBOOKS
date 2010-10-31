class TranslationsController < ApplicationController
  before_filter :require_admin, :except => [:download]

  def new
    begin
      book = Book.find(params[:book])
    rescue ActiveRecord::RecordNotFound
      redirect_to books_path
      return
    end
    @translation = book.translations.build
    @translation.book = book
  end
  
  def create
    begin
      @translation = Translation.new(params[:translation])
      @translation.book = Book.find(params[:book])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Book not found'
      redirect_to books_url
    end

    if @translation.save
      flash[:notice] = "Successfully created translation."
      redirect_to @translation.book
    else
      render :action => 'new'
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
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Translation was not found'
      redirect_to books_url
    end

    if @translation.save
      flash[:notice] = 'Successfully updated the translation.'
      redirect_to @translation.book
    else
      render :action => :edit
    end
  end
  
  def destroy
    @translation = Translation.find(params[:id])
    @translation.destroy

    redirect_to edit_book_path(@translation.book)
  end

  def download
    @translation = Translation.find(params[:id])
    @book = Book.find(@translation.book_id)

    if mobile? or user_admin
      send_translation @translation, @book
    else
        if params.key? :captcha_is_there and verify_recaptcha
        send_translation @translation, @book
        return
      else
        @translation.errors.add_to_base "You didn't write the captcha correctly." if params.key? :captcha_is_there
      end

      render 'translations/captcha.html.erb'
    end
  end

  private

    def send_translation(translation, book)
      filename = book.filename

      begin
        book.downloads += 1
        book.save
      rescue
      end
      
      send_file translation.path_to_file, :filename => filename, :type=>"application/epub+zip", :x_sendfile => APP_CONFIG['x_sendfile']
    end
end
