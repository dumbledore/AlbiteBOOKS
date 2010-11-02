class TranslationsController < ApplicationController
  before_filter :require_admin, :except => [:download]

  def new
    begin
      book = Book.find(params[:book])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Book was not found'
      redirect_to books_url
    end
    
    @translation = book.translations.build
    @translation.book = book
  end
  
  def create
    begin
      @translation = Translation.new(params[:translation])
      @translation.book = Book.find(@translation.book_id)
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Book was not found'
      redirect_to books_url
      return
    end

    if @translation.save
      flash[:notice] = "Successfully created translation."
      redirect_to edit_book_url(@translation.book)
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
      return
    end
  end

  def update
    begin
      @translation = Translation.find(params[:id], :include => :book)
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Translation was not found'
      redirect_to books_url
      return
    end

    if @translation.update_attributes(params[:translation])
      flash[:notice] = 'Successfully updated translation.'
      redirect_to edit_book_url(@translation.book)
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
    @translation = Translation.find(params[:id], :include => :book)

    if mobile? or user_admin
      send_translation @translation
    else
        if params.key? :captcha_is_there and verify_recaptcha
        send_translation @translation
        return
      else
        @translation.errors.add_to_base "You didn't write the captcha correctly." if params.key? :captcha_is_there
      end

      render 'translations/captcha.html.erb'
    end
  end

  private

    def send_translation(translation)
      filename = translation.book.filename

      begin
        translation.book.downloads += 1
        translation.book.save
      rescue
        puts "Couldn't increment download count"
      end
      
      send_file translation.path_to_file, :filename => filename, :type=>"application/epub+zip", :x_sendfile => APP_CONFIG['x_sendfile']
    end
end
