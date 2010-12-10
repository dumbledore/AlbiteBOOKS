module ActiveRecord
  class Base
    def self.random(include = nil, how_many_records = 1)
      if (c = count - how_many_records + 1) > 0
        r = rand(c)
        if include
          find(:all, :offset => r, :limit => how_many_records, :include => include)
        else
          find(:all, :offset => r, :limit => how_many_records)
        end
      end
    end
  end
end