module MiscHelper
  def letters_index
    letters = [link_to('#', {:letter => '*'}, :class => 'letter')]
    for letter in 'A'..'Z'
      letters << link_to(letter, {:letter => letter}, :class => 'letter')
    end
    letters.join(' | ')
  end
end