class Book < ActiveRecord::Base
  belongs_to :author
  belongs_to :alias_title, :class_name => 'BookAlias'

  has_many :book_aliases, :order => :title,     :dependent => :destroy
  has_many :translations,                       :dependent => :destroy

  attr_accessible :alias_title_id, :title, :freebase_uid, :thumbnail_url, :author_id, :tags, :ready,
                  :description, :date_of_first_publication, :original_language, :number_of_pages,
                  :genre_list, :subject_list

  acts_as_taggable_on :genres, :subjects

  validates_presence_of :title
  validates_uniqueness_of :freebase_uid, :allow_blank => true

  validate :author_exists

  before_create do |book|
    book.alias_title = BookAlias.create(:title => book.title, :book_id => 0)
  end

  before_save :fill_in_from_freebase

  after_create do |book|
    book.alias_title.book = book
    book.alias_title.save
    book.save
  end

  after_update do |book|
    book.alias_title.save
  end

  include Freebase

  def title=(title)
    title.strip!
    self[:title] = title
    self.alias_title.title = title unless self.alias_title.nil?
  end

  def author_exists
#    errors[:base] << "Author does not exist." unless Author.exists?(self.author)
    errors.add_to_base "Author does not exist." unless Author.exists?(self.author_id)
  end

  def fill_in_from_freebase

    if not self.freebase_uid.empty? and self.errors.empty? #calling errors.empty? instead of valid? because it's called AFTER validation
      get_freebase_info if self.freebase_data.nil?
      return false if self.freebase_data.nil?

      # thumbnail
      self.thumbnail_url = self.freebase_data['thumbnail'] if self.thumbnail_url.blank? and not self.freebase_data['thumbnail'].nil?

      # filling genres
      if self.genre_list.blank?
        begin
          genres = []
          self.freebase_data['properties']['/book/book/genre']['values'].each do |genre|
            genres << genre['text'].downcase if genre['text']
          end
          self.genre_list = genres.join ','
        rescue
        end
      end

      #filling subjects
      if self.subject_list.blank?
        begin
          subjects = []
          self.freebase_data['properties']['/book/written_work/subjects']['values'].each do |subject|
            subjects << subject['text'].downcase if subject['text']
          end
          self.subject_list = subjects.join ','
        rescue
        end
      end

      # cache these values for the mobile version
      self.description = self.freebase_data['description'] if self.description.blank? and not self.freebase_data['description'].nil?

      unless self.freebase_data['properties'].nil?

        if self.date_of_first_publication.blank?
          begin
            self.date_of_first_publication = self.freebase_data['properties']['/book/written_work/date_of_first_publication']['values'][0]['text']
          rescue
          end
        end

        if self.original_language.blank?
          begin
            self.original_language = self.freebase_data['properties']['/book/written_work/original_language']['values'][0]['text']
          rescue
          end
        end

        if self.number_of_pages.blank?
          begin
            self.number_of_pages = self.freebase_data['properties']['/book/book_edition/number_of_pages']['values'][0]['text']
          rescue
          end
        end
      end
    end
  end

  def create_aliases
    get_freebase_info if self.freebase_data.nil?
    unless self.freebase_data.nil?
      if not self.freebase_data['alias'].nil? and self.freebase_data['alias'].class == Array
        self.freebase_data['alias'].each do |aliaz|
          BookAlias.create(:title => aliaz, :book => self, :book_id => self.id)
        end
      end
    end
  end
end
