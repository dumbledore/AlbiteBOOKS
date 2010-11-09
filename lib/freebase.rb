module Freebase
  attr_accessor :freebase_data

  def freebase_response(freebase_id)
    require 'net/http'
    require 'uri'

    begin
      data = Net::HTTP.get(URI.parse("http://www.freebase.com/experimental/topic/standard?id=#{freebase_id}"))
    rescue
      puts "ERROR: Couldn't download the data!"
      return
    end

    begin
      result = JSON.parse data
    rescue
      puts "ERROR: couldn't parse the data!"
      return
    end

    if not result[freebase_id]['code'] == "/api/status/ok"
      puts "ERROR: status is not ok"
      return
    end

#    if result[freebase_id]['result']['description'].nil?
#      puts "ERROR: Incomplete data was returned"
#      return
#    end

    result[freebase_id]['result']
  end

  def get_freebase_info
    self.freebase_data = freebase_response(self.freebase_uid)
#    self.freebase_valid = false if self.freebase_data.nil?
    if self.freebase_data.nil?
      errors.add('freebase_uid', ': there was a problem fetching the data from Freebase.')
    end
  end
end
