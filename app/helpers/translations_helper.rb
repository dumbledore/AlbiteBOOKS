module TranslationsHelper
  def translations_list(translations)
    if translations and not translations.empty?
      html = '<ul>'

      for translation in translations
        text = []
        text << 'Original text' if translation.original
        text << Languages::LANGUAGES[translation.language][0]
        text << h(translation.date_of_publication) unless translation.date_of_publication.empty?
        text << h(translation.note) unless translation.note.empty?

        html <<
          %[
            <li>
              #{link_to text.join(', '), translation_url(translation)}
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
        text << 'Original text' if translation.original
        text << h(translation.date_of_publication) unless translation.date_of_publication.empty?
        text << h(translation.note) unless translation.note.empty?

        html << mobile_link_to(translation_url(translation),
                               Languages::LANGUAGES[translation.language][0], text.join('<br />'), true, 'download')
      end

      html
    else
      '<p><i>Nothing to download yet.</i></p>'
    end
  end
end