module MiscHelper
  def letters_index(hide, title, letter_name = nil)
    unless hide
      letters = [link_to('#', {:letter => '*'}, :class => 'letter')]

      for letter in 'A'..'Z'
        letters << link_to(letter, {:letter => letter}, :class => 'letter')
      end

      %[
          <h1 class="letter">
            #{title}
            <span class="letter">#{letter_name}</span><br />
            #{letters.join(' | ')}
          </h1>
      ]
    else
      %[<h1>#{title}</h1>]
    end
  end
end