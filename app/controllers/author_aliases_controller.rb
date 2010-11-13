class AuthorAliasesController < ApplicationController
  before_filter :require_admin
  
  def new
    begin
      @author = Author.find(params[:author])
      @alias = @author.author_aliases.build
    rescue ActiveRecord::RecordNotFound
      redirect_to authors_url
    end
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
    begin
      @alias = AuthorAlias.find(params[:id], :include => :author)
      @author = @alias.author
    rescue ActiveRecord::RecordNotFound
      redirect_to authors_url
    end
  end

  def update
    begin
      @alias = AuthorAlias.find(params[:id], :include => :author)
      @author = @alias.author

      if @alias.update_attributes(params[:author_alias])
        flash[:notice] = "Successfully updated alias."
        redirect_to edit_author_path(@alias.author_id)
      else
        flash[:error] = "Couldn't update alias."
        render :action => 'edit'
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to authors_url
    end
  end

  def destroy
    begin
      @alias = AuthorAlias.find(params[:id])

      if @alias == @alias.author.alias_name
        flash[:error] = "Names are not allowed to be destroyed."
      else
        @alias.destroy
      end

      redirect_to edit_author_path(@alias.author_id)
    rescue ActiveRecord::RecordNotFound
      redirect_to authors_url
    end
  end
end
