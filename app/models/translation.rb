class Translation < ActiveRecord::Base
  require 'lib/languages.rb'

  belongs_to :book

  attr_accessible :language, :book_id
  attr_accessor :book_file, :original

  validate :book_exists

  validates_numericality_of :language, :only_integer => true, :allow_blank => true
  validates_inclusion_of :language, :in => 0..Languages::LANGUAGES.size-1, :allow_blank => true
  validates_presence_of :book_file, :original

  def after_create

    if self.original == "1" #it's a checkbox! 
      #update book
      book = Book.find(self.book_id)
      book.translation_id = self.id
      book.save
    end

    #upload file
    unless book_file.nil?

      # If for some reason there is a file with this name, delete it
      File.delete(self.path_to_file) if File.exists?(self.path_to_file)
      
      if book_file.instance_of?(Tempfile)
        FileUtils.copy(book_file.local_path, path_to_file)
      else
        File.open(self.path_to_file, "wb") { |f| f.write(book_file.read) }
      end
    end
  end

  def after_destroy
    File.delete(self.path_to_file) if File.exists?(self.path_to_file)
  end

  def book_exists
#    errors[:base] << "Book does not exist." if not self.book.nil? and not Book.exists?(self.book)
    errors.add_to_base "Book does not exist." if not self.book_id.nil? and not Book.exists?(self.book_id)
  end

  def path_to_file
#    Rails.root.join('data', 'books', "#{self.id}.epub")
    @path_to_file ||= File.join(RAILS_ROOT, 'data', 'books', "#{self.id}.epub")
  end
end