module ActiveRecord
  class Base
    def self.random(include = nil, how_many_records = 1)
      if (c = count - how_many_records + 1) > 0
          r = rand(c) + 1
          records = Array(r .. r + how_many_records - 1)
        if include
          find(records, :include => include)
        else
          find(records)
        end
      end
    end
  end
end