module ExtractSubjects
  require 'rexml/document'
  include REXML

  def extract_subjects(file)
    Zip::ZipFile.open(file) do |zip_file|
      opf_file = get_opf_file(zip_file.file.read('META-INF/container.xml'))
      get_subjects(zip_file.file.read(opf_file))
    end
  end

  private

  def get_opf_file(xml_file)
    xml_doc = Document.new(xml_file)
    root_file = root_file = XPath.first(xml_doc, '//rootfile')
    root_file.attributes['full-path']
  end

  def get_subjects(xml_file)
    all_genres = []
    all_genres_tags = Book.tag_counts_on(:genres)
    all_genres_tags.each {|tag| all_genres << tag.name}
    subjects = []
    genres = []

    xml_doc = Document.new(xml_file)

    ['//subject', '//dc:subject'].each do |t|
      XPath.each(xml_doc, t) do |e|
        s = e.text.split('--')
        s.each do |s|
          s = s.strip.downcase
          if all_genres.include? s
            genres << s
          else
            subjects << s
          end
        end
      end
    end
    
    [subjects, genres]
  end
end