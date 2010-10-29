module AlbiteDate

  OFFSET = 100000;

  def date_to_store(str)
    parts = str.split('-')

    begin
      year = 0
      month = 0
      day = 0

      index = 0;

      negative = parts[0].empty?
      index += 1 if negative

      year = parts[index].to_i if index < parts.length

      index += 1
      month = parts[index].to_i if index < parts.length
      month = 0 if month < 0 or month > 12

      index += 1
      day = parts[index].to_i if index < parts.length
      day = 0 if day < 0 or day > 31

      if negative
        year = OFFSET - year
        month = 12 - month
        day = 31 - day
      else
        year += OFFSET
      end

      year = year.to_s
      month = month.to_s
      day = day.to_s

      month = ('0' * (2 - month.length)) + month if month.length < 2
      day = ('0' * (2 - day.length)) + day if day.length < 2

      result = (year + month + day).to_i

      if (result < 0 or result > 2 * OFFSET)
        # Something is wrong. Valid values are in the interval: 0 ... 2 * OFFSET, where
        # OFFSET is the absolute zero
        return OFFSET
      end

      return result

    rescue
      return OFFSET
    end
  end

  def date_from_store(num)
    begin
      date = get_date(num)

      dates = []
      puts date.inspect
      dates << date[:year]  unless (date[:year] == 0 && date[:month] == 0 && date[:day] == 0)
      dates << date[:month] unless (date[:month] == 0 && date[:day] == 0)
      dates << date[:day] unless date[:day] == 0

      result = ''
      result += '-' if date[:negative] and not dates.empty?
      result += dates.join('-')
    rescue
      return ''
    end

    result
  end

  def date_number_to_readable_string(num)
    
  end

  def get_date(num)

    t = num

    day = num % 100
    t /= 100

    month = t % 100
    t /= 100

    year = t 

    negative = num < OFFSET

    if negative
      year = OFFSET - year
    else
      year = year - OFFSET
      month = 12 - month
      day = 31 - day
    end

    {:negative => negative, :year => year, :month => month, :day => day}
  end
end