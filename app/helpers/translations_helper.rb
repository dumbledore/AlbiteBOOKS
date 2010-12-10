module TranslationsHelper
  def translations_list(translations)
    if translations and not translations.empty?
      html = '<ul>'

      for translation in translations
        text = []
        text << Languages::LANGUAGES[translation.language][0]
        text << h(translation.date_of_publication) unless translation.date_of_publication.empty?
        text << h(translation.note) unless translation.note.empty?

        html <<
          %[
            <li>
              #{link_to text.join(', '), translation_url(translation), :class => 'item'}
              #{edit_translation_links(translation)}
            </li>
          ]
      end
      
      html << '</ul>'
    else
      '<p><i>Nothing to download yet.</i></p>'
    end
  end

  def translations_list_mobile(translations)
    if translations and not translations.empty?
      html = ''

      for translation in translations
        text = []
        text << h(translation.date_of_publication) unless translation.date_of_publication.empty?
        text << h(translation.note) unless translation.note.empty?

        html << mobile_link_to(translation_url(translation),
                               Languages::LANGUAGES[translation.language][0],
                               text.join('<br />'), true, 'download', true, true)
      end

      html
    else
      '<p><i>Nothing to download yet.</i></p>'
    end
  end

  def translation_file_url(translation)
    path = "/books/#{translation.id}/#{translation.filename}"
    path += '?' + File.mtime('public' + path).to_i.to_s if File.exist?('public' + path)
    path
  end
end