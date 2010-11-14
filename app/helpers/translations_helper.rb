module TranslationsHelper
  def translation_in_list(translation)
    text = []
    text << 'Original text' if translation.original
    text << Languages::LANGUAGES[translation.language][0]
    text << h(translation.date_of_publication) unless translation.date_of_publication.empty?
    text << h(translation.note) unless translation.note.empty?

    %[
      <li>
        #{link_to text.join(', '), translation_url(translation)}
        #{edit_translation_links(translation)}
    </li>
    ]
  end

  def translation_in_list_mobile(translation)
    text = []
    text << 'Original text' if translation.original
    text << h(translation.date_of_publication) unless translation.date_of_publication.empty?
    text << h(translation.note) unless translation.note.empty?

    mobile_link_to(translation_url(translation),
                   Languages::LANGUAGES[translation.language][0], text.join('<br />'), true, 'download')
  end
end