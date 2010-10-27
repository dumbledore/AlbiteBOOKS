class HomeController < ApplicationController
  def index
#    @books = Book.includes(:author).order('created_at DESC').limit(300) #TODO, change the limit to a smaller value
    @books = Book.find(:all, :limit => 300, :order => 'created_at DESC', :include => :author)
  end
end
