module Lettercode
  def process_letter(letter)
    letter = letter.ord
    
    case letter
      when 65..90 then return letter + 32
      when 97..122 then return letter
    end

    return 0
  end
end