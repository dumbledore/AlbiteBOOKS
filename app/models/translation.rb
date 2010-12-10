class Translation < ActiveRecord::Base
  require 'digest/md5'
  require 'lib/epub'
  include EPUB

  belongs_to :book

  attr_accessible :note, :language, :original, :date_of_publication, :source_url, :book_id, :book_file
  attr_accessor :book_file

  validate :book_exists

  validates_numericality_of :language, :only_integer => true, :allow_blank => true
  validates_inclusion_of :language, :in => 0..Languages::LANGUAGES.size-1, :allow_blank => true
  validates_presence_of :book_file, :on => :create

  def before_validation
    unless book_file.nil?
      update_filename
      update_md5
      update_metadata
    end
  end

  def after_save
    upload_file unless book_file.nil?
  end

  def after_destroy
    delete_file
    delete_dir
  end

  def book_exists
#    errors[:base] << "Book does not exist." if not self.book.nil? and not Book.exists?(self.book)
    errors.add_to_base "Book does not exist." unless Book.exists?(self.book_id)
    false
  end

  def filename
    @filename ||= "#{self.id.to_s}-#{self[:filename]}#{lang_trailer}.epub"
  end

  def path_to_file
    @path_to_file ||= File.join(RAILS_ROOT, 'public', 'books', self.id.to_s, filename)
  end

  def path_to_dir
    @path_to_dir ||= File.dirname(path_to_file)
  end

  def filesize
    @filesize ||= (File.size(path_to_file) / 1024).round.to_s + " KB"
  end

  private

  def update_metadata
    begin
      # get metadata
      subjects, genres, url, lang = get_metadata(book_file.instance_of?(Tempfile) ? book_file.local_path : book_file)

      # subjects & genres
      begin
        book.subject_list += subjects if not subjects.nil? and not subjects.empty?
        book.genre_list += genres if not genres.nil? and not genres.empty?
        book.save
      rescue
      end

      # source url
      self.source_url = 'http://www.gutenberg.org/ebooks/' + url if not url.nil? and (source_url.empty? or source_url == 'http://www.gutenberg.org/ebooks/')

      # language
      self.language = Languages::get_number(lang) if lang
    rescue => msg
      puts msg
    end
  end

  def lang_trailer
    if self.language == Languages::UNSPECIFIED or self.language == Languages::DEFAULT
      ''
    else
      '-' + Languages::LANGUAGE_CODES[self.language]
    end
  end
  
  def update_filename

    name = self.book.title

    # NOTE: File.basename doesn't work right with Windows paths on Unix
    # get only the filename, not the whole path

    # Finally, replace all non alphanumeric, underscore or periods with underscore
    name.gsub! /[^\w\.\- ]/, ''

    name.gsub!(/[^0-9A-Za-z\- ]/, '')

    name = name.split ' '

    filename = []
    len = 0

    for word in name
      if len + word.length > 32 #[alices, adventures, in, wonderland]
        break
      end
      filename << word.mb_chars.downcase
      len += word.length + 1
    end

    filename = filename.join('_')

    self.filename = (filename.empty? ? 'untitled' : filename)
  end

  def update_md5
    self.md5 = Digest::MD5.hexdigest(book_file.read)
  end

  def upload_file

    # If for some reason there is a file with this name, delete it
    delete_file

    # Create the dir if it doesn't exist
    Dir::mkdir(path_to_dir, 0644) unless File.exists?(path_to_dir)

    # Copy the file
    if book_file.instance_of?(Tempfile)
      FileUtils.copy(book_file.local_path, path_to_file)
    else
      File.open(self.path_to_file, "wb") { |f| f.write(book_file.read) }
    end
  end

  def delete_file
    if File.exists?(path_to_dir)
      Dir.foreach(path_to_dir) do |f|
        if (f == '.') or (f == '..') then next
        else
          File.delete(File.join(path_to_dir, f))
        end
      end
    end
  end

  def delete_dir
    Dir.rmdir(path_to_dir) if File.exists?(path_to_dir)
  end
end