module EPUB
  require 'rexml/document'
  include REXML

  def get_metadata(file)
    Zip::ZipFile.open(file) do |zip_file|
      opf_file = get_opf_file(zip_file.file.read('META-INF/container.xml'))
      xml_doc = Document.new(zip_file.file.read(opf_file))
      
      get_subjects(xml_doc) + [
        get_url(xml_doc),
        get_language(xml_doc)
      ]
    end
  end

  private

  def get_opf_file(xml_file)
    xml_doc = Document.new(xml_file)
    root_file = XPath.first(xml_doc, '//rootfile')
    root_file.attributes['full-path']
  end

  def get_subjects(xml_doc)
    begin
      all_genres = []
      all_genres_tags = Book.tag_counts_on(:genres)
      all_genres_tags.each {|tag| all_genres << tag.name}
      subjects = []
      genres = []

      ['//subject', '//dc:subject'].each do |t|
        XPath.each(xml_doc, t) do |e|
          s = e.text.split('--')
          s.each do |s|
            s = s.strip.downcase
            if GENRES.include? s or all_genres.include? s
              genres << s
            else
              subjects << s
            end
          end
        end
      end
      [subjects, genres]
    rescue => msg
      puts msg
    end
  end

  def get_url(xml_doc)
    begin
      XPath.each(xml_doc, '//item') do |e|
        href = e.attributes['href']
        if href =~ /.*?.htm[l]{0,1}/
          m = href.match('[0-9]+')
          return m[0] if m
        end
      end
    rescue => msg
      puts msg
    end
  end

  def get_language(xml_doc)
    begin
      XPath.first(xml_doc, '//dc:language').text[0..1].downcase
    rescue => msg
      puts msg
    end
  end
end