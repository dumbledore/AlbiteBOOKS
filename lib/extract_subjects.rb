module ExtractSubjects
  require 'rexml/document'
  include REXML

  def extract_subjects(file)
    Zip::ZipFile.open(file) do |zip_file|
      opf_file = get_opf_file(zip_file.file.read('META-INF/container.xml'))
      subjects = get_subjects(zip_file.file.read(opf_file))
      subjects.each {|s| puts s.inspect}
    end
  end

  private

  def get_opf_file(xml_file)
    xml_doc = Document.new(xml_file)
    root_file = root_file = XPath.first(xml_doc, '//rootfile')
    root_file.attributes['full-path']
  end

  def get_subjects(xml_file)
    xml_doc = Document.new(xml_file)
    subjects = []

    ['//subject', '//dc:subject'].each do |t|
      XPath.each(xml_doc, t) do |e|
        s = e.text.split('--')
        s.each do |s|
          subjects << s.strip
        end
      end
    end
    
    subjects
  end
end