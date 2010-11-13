module Lettercode
  IS_ID_REGEXP = Regexp.new(/\d+/).freeze
  LETTERS = ('A'..'Z').to_a.freeze

  def is_id(str)
    not (str.match(IS_ID_REGEXP).nil?)
  end

  def process_letter(letter)
    letter = letter.ord

    case letter
      when 65..90 then return letter + 32
      when 97..122 then return letter
    end

    return 0
  end

  def name_for_letter_number(num)
    unless (97..122).include?(num)
      return '#'
    end

    LETTERS[num - 97]
  end
end