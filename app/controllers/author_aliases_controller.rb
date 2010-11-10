class AuthorAliasesController < ApplicationController
  before_filter :require_admin
  
  def new
    begin
      @author = Author.find(params[:author])
    rescue ActiveRecord::RecordNotFound
      redirect_to authors_path# if not params[:author] or author.nil?
      return
    end
    @alias = @author.author_aliases.build
  end
  
  def create
    @alias = AuthorAlias.new(params[:author_alias])
    if @alias.save
      flash[:notice] = "Successfully created alias."
      redirect_to edit_author_path(@alias.author_id)
    else
      flash[:error] = "Couldn't create alias."
      render :action => 'new'
    end
  end

  def edit
    @alias = AuthorAlias.find(params[:id], :include => :author)
    @author = @alias.author
  end

  def update
    @alias = AuthorAlias.find(params[:id], :include => :author)
    @author = @alias.author

    if @alias.update_attributes(params[:author_alias])
      flash[:notice] = "Successfully updated alias."
      redirect_to edit_author_path(@alias.author_id)
    else
      flash[:error] = "Couldn't update alias."
      render :action => 'edit'
    end
  end

  def destroy
    @alias = AuthorAlias.find(params[:id])

    if @alias == @alias.author.alias_name
      flash[:error] = "Names are not allowed to be destroyed."
    else
      @alias.destroy
    end

    redirect_to edit_author_path(@alias.author_id)
  end

end
