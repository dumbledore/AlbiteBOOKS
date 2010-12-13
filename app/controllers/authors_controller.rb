class AuthorsController < ApplicationController
  include Lettercode
  before_filter :require_admin, :except => [:index, :show, :search, :search_form]

  def new
    @author = Author.new
  end
  
  def create
    begin
      Author.transaction do
        @author = Author.new(params[:author])

        if @author.save
          @author.create_aliases # create additional resources after save
          flash[:notice] = 'Successfully created author.'
          redirect_to @author
        else
          render :action => 'new'
        end
      end
    rescue => msg
      puts 'ERROR: ' + msg.inspect;
      flash[:error] = 'Something is wrong with the transaction'
      render :action => 'new'
    end
  end

  def edit
    begin
      @author = Author.find(params[:id], :include => :author_aliases)
      @aliases = @author.author_aliases
      @books = @author.books
      @book_thumbnails = false
      @no_books_message = 'No books have been added, so far.'
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Author was not found'
      redirect_to authors_url
    end
  end

  def update
    begin
      @author = Author.find(params[:id], :include => :author_aliases)

      Author.transaction do
        if @author.update_attributes(params[:author])
          flash[:notice] = 'Successfully updated author.'
          redirect_to @author
        else
          render :action => 'edit'
        end
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Author was not found'
      redirect_to authors_url
    rescue => msg
      puts 'ERROR: ' + msg.inspect;
      flash[:error] = 'Something is wrong with the transaction'
      render :action => 'edit'
    end
  end

  def destroy
    begin
      @author = Author.find(params[:id])
      @author.destroy
      flash[:notice] = 'Successfully deleted author and their books.'
      redirect_to authors_url
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Author was not found'
      redirect_to authors_url
    end
  end

  def index
    unless mobile?
      conditions = nil

      unless APP_CONFIG['hide_author_index']
        letter = process_letter((params[:letter]) ? params[:letter] : 'a')
        conditions = "letter = '#{letter}'"
        @letter_name = name_for_letter_number(letter)
      end

      @author_aliases = AuthorAlias.paginate(
              :page => params[:page], :per_page => APP_CONFIG['paginate']['index']['html'],
              :conditions => conditions, :order => :name_reversed, :include => :author)
      @no_author_aliases_message = 'There are no authors, whose family name starts with this letter.'
    end
  end

  def show
    begin
      @author = Author.find(params[:id], :include => [:author_aliases, :alias_name, :books])
      @books = @author.books
      if mobile?
        @books = @books.paginate(:page => params[:page], :per_page => APP_CONFIG['paginate']['search']['html'])
      end
      @book_thumbnails = true
      @no_books_message = 'No books have been added, so far.'
      @show_publication_date = true
      @freebase_item = @author
      @disqus = 'author_' + @author.id.to_s
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Author not found.'
      redirect_to authors_url
    end
  end
  
  def search
    @query = params[:query]

    if @query and not @query.empty?
      author_ids = AuthorAlias.with_query(@query).find(:all,:select=>'author_id').map {|x| x.author_id}.uniq
      @authors = Author.find(author_ids).paginate(
        :page => params[:page], :per_page => APP_CONFIG['paginate']['search']['html'],
        :order => :name_cached
      ) if author_ids
    end

    @author_thumbnails = true
    @no_authors_message = 'No authors have been found for this query.'
  end

  def search_form
    if params[:query]
      redirect_to search_authors_url params[:query]
    else
      render :search
    end
  end
end