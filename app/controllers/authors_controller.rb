class AuthorsController < MixedController

  def index
#    page = (params[:page]) ? params[:page] : 0
    unless APP_CONFIG['hide_author_index']
      letter = process_letter((params[:id]) ? params[:id] : 'a')
#      @authors_name_aliases = Alias.includes(:author).where(["name_reversed LIKE ?", "#{letter}%"]).order(:name_reversed)
      @authors_name_aliases = Alias.find(:all, :include => :author, :conditions => "letter = '#{letter}'", :order => :name_reversed)
      @letter_name = name_for_letter_number(letter)
      @myurl = authors_url
    else
      @authors_name_aliases = Alias.find(:all, :include => :author, :order => :name_reversed)
    end
    render :action => 'index'
  end

  def show
    begin
#      @author = Author.includes([:aliases, :alias_name]).find(params[:id])
      @author = Author.find(params[:id], :include => [:aliases, :alias_name])
      @mobile = mobile?
      render :action => 'show'
    rescue ActiveRecord::RecordNotFound
      redirect_to authors_url
    end
  end
  
  def new
    @author = Author.new
  end
  
  def create
    begin
      Author.transaction do
        @author = Author.new(params[:author])
        @author.fill_in_from_freebase unless @author.freebase_uid.empty?
        if @author.errors.empty? and @author.save
          @author.create_aliases # create additional resources
          flash[:notice] = "Successfully created author."
          redirect_to @author
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
      @author = Author.find(params[:id])
    end
    rescue ActiveRecord::RecordNotFound
      redirect_to authors_url
  end

  def update
    begin
      @author = Author.find(params[:id])
      @author.attributes = params[:author]

      Author.transaction do
        @author.fill_in_from_freebase unless @author.freebase_uid.empty?
        if @author.errors.empty? and @author.save
          flash[:notice] = "Successfully updated author."
          redirect_to @author
        else
          render :action => 'edit'
        end
      end
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to authors_url
  end
  
  def destroy
    begin
      @author = Author.find(params[:id])
      @author.destroy

      flash[:notice] = "Successfully deleted author and their books."
      session[:restore] = request.referer
    rescue ActiveRecord::RecordNotFound
    end
    redirect_to authors_url
  end
end