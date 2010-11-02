class AuthorsController < ApplicationController
  before_filter :require_admin, :except => [:index, :show]

  require 'lib/lettercode.rb'
  include Lettercode

  def index
    unless APP_CONFIG['hide_author_index']
      letter = process_letter((params[:letter]) ? params[:letter] : 'a')
      @authors_name_aliases = Alias.find(:all, :include => :author, :conditions => "letter = '#{letter}'", :order => :name_reversed)
      @letter_name = name_for_letter_number(letter)
    else
      @authors_name_aliases = Alias.find(:all, :include => :author, :order => :name_reversed)
    end
    render :action => 'index'
  end

  def show
    begin
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

        if @author.save
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
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Author was not found'
      redirect_to authors_url
    end
  end

  def update
    begin
      @author = Author.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Author was not found'
      redirect_to authors_url
      return
    end

    begin
      Author.transaction do
        if @author.update_attributes(params[:author])
          flash[:notice] = "Successfully updated author."
          redirect_to @author
        else
          render :action => 'edit'
        end
      end
    rescue => msg
      puts "ERROR: " + msg.inspect;
      flash[:error] = "Something is wrong with the transaction"
      render :action => 'edit'
    end
  end

  def destroy
    begin
      @author = Author.find(params[:id])
      @author.destroy
      flash[:notice] = "Successfully deleted author and their books."
      redirect_to authors_url
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Author was not found'
      redirect_to authors_url
    end
  end
end