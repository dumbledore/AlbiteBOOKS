class Author < ActiveRecord::Base
  belongs_to :alias_name, :class_name => 'Alias'

  has_many :aliases, :order => :name_reversed, :dependent => :destroy
  has_many :books, :order => :title, :dependent => :destroy
  
  attr_accessible :alias_name_id, :name, :freebase_uid, :thumbnail_url, :ready,
                  :description, :date_and_place_of_birth, :date_and_place_of_death, :country_of_nationality
  
  validates_presence_of :name
  validates_uniqueness_of :freebase_uid, :allow_blank => true

  before_create do |author|
    author.alias_name = Alias.create(:name => author.name, :author_id => 0)
  end

  before_save :fill_in_from_freebase

  after_create do |author|
    author.alias_name.author = author
    author.alias_name.save
    author.cache_name
    author.save
  end

  after_update do |author|
    author.alias_name.save
  end

  require File.expand_path('app/models/alias.rb')
  require File.expand_path('app/models/book.rb')
  require File.expand_path('lib/freebase.rb')
  include Freebase

  def name
    if self.alias_name.nil?
      # Creating author
      @name
    else
      # Showing author's name
      self.alias_name.name
    end
  end

  def name=(name)
  if self.alias_name.nil?
      # Creating author
      @name = name
    else
       # Updating author
      self.alias_name.name = name
      # Caching name
      cache_name
    end
  end

  def cache_name
    self.name_cached = self.alias_name.name_abbreviated(:name)
  end

  def fill_in_from_freebase

    if not self.freebase_uid.empty? and self.errors.empty? #calling errors.empty? instead of valid? because it's called AFTER validation
      get_freebase_info if self.freebase_data.nil?
      return false if self.freebase_data.nil?

      # thumbnail
      self.thumbnail_url = self.freebase_data['thumbnail'] if self.thumbnail_url.blank? and not self.freebase_data['thumbnail'].nil?

      # cache these values for the mobile version
      self.description = self.freebase_data['description'] if self.description.blank? and not self.freebase_data['description'].nil?
      
      unless self.freebase_data['properties'].nil?

        if self.date_and_place_of_birth.blank?
          birth = []
          
          begin
            birth << self.freebase_data['properties']['/people/person/date_of_birth']['values'][0]['text']
          rescue
          end

          begin
            birth << self.freebase_data['properties']['/people/person/place_of_birth']['values'][0]['text']
          rescue
          end

          self.date_and_place_of_birth = birth.join(', ')
        end

        if self.date_and_place_of_death.blank?
          death = []

          begin
            death << self.freebase_data['properties']['/people/deceased_person/date_of_death']['values'][0]['text']
          rescue
          end

          begin
            death << self.freebase_data['properties']['/people/deceased_person/place_of_death']['values'][0]['text']
          rescue
          end

          self.date_and_place_of_death = death.join(', ')
        end

        if self.country_of_nationality.blank?
          begin
            countries = []
            for country in self.freebase_data['properties']['/people/person/nationality']['values']
              countries << country['text']
            end
            self.country_of_nationality = countries.join(', ')
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
          Alias.create(:name => aliaz, :author => self)
        end
      end
    end
  end
end
