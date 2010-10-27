class AliasesController < ApplicationController
  before_filter :require_admin
  
  def new
    begin
      @author = Author.find(params[:author])
    rescue ActiveRecord::RecordNotFound
      redirect_to authors_path# if not params[:author] or author.nil?
    end
    @alias = @author.aliases.build
  end
  
  def create
    @alias = Alias.new(params[:alias])
    if @alias.save
      flash[:notice] = "Successfully created alias."
      redirect_to edit_author_path(@alias.author_id)
    else
      flash[:error] = "Couldn't create alias."
      render :action => 'new'
    end
  end

  def edit
    @alias = Alias.find(params[:id], :include => :author)
    @author = @alias.author
  end

  def update
    @alias = Alias.find(params[:id], :include => :author)
    @author = @alias.author

    if @alias.update_attributes(params[:alias])
      flash[:notice] = "Successfully created alias."
      redirect_to edit_author_path(@alias.author_id)
    else
      flash[:error] = "Couldn't create alias."
      render :action => 'new'
    end
  end

  def destroy
    @alias = Alias.find(params[:id])

    if @alias == @alias.author.alias_name
      flash[:error] = "Names are not allowed to be destroyed."
    else
      @alias.destroy
    end

    redirect_to edit_author_path(@alias.author_id)
  end

end
