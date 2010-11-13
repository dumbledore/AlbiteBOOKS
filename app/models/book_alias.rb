class BookAlias < ActiveRecord::Base
  belongs_to :book
  attr_accessible :title, :book, :book_id

  validates_presence_of :title
  validate :book_exists

  acts_as_indexed :fields => [:title]

  include Lettercode

  def book_exists
    errors.add_to_base("Book does not exist.") if self.book_id > 0 and not Book.exists?(self.book_id)
  end

  def title=(title)
    unless title.blank?
      # copy the first letter to the letter attribute
      self.letter = process_letter(title.mb_chars[0])

      # save the title
      self[:title] = title
    end
  end
end
