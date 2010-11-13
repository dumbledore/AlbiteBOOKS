class AuthorAlias < ActiveRecord::Base

  belongs_to :author

  attr_accessible :name, :name_reversed, :author_id, :author
  attr_readonly :name_abbreviated

  acts_as_indexed :fields => [:name]

  validates_presence_of :name
  validate :author_exists

  def author_exists
#    errors[:base] << "Author does not exist." if not self.author.nil? and not Author.exists?(self.author)
    errors.add_to_base("Author does not exist.") if self.author_id > 0 and not Author.exists?(self.author_id)
#    errors.add_to_base "Author does not exist." if not self.author_id == 0 and not Author.exists?(self.author)
  end

  def name
    #moving name to the left
    normal_name = self[:name_reversed].mb_chars.split(' ')
    normal_name.push(normal_name.shift)
    normal_name.join(' ')
  end

  def name=(name)

    unless name.blank?

      # moving name to the right
      r_name = name.mb_chars.split(' ')
      r_name.unshift(r_name.pop)

      # assert the family name (which is at the first place now) starts with a capital
      r_name[0][0] = r_name[0][0..0].upcase

      # copy the first letter to the letter attribute
      self.letter = process_letter(r_name[0])

      # save the name
      self.name_reversed = r_name.join(' ')
    end
  end

  def name_reversed
    name = self[:name_reversed].mb_chars.split(' ')
    return self[:name_reversed] if name.size < 2
    name[0] += ','
    name.join(' ')
  end

  def name_abbreviated(type)
    name_abb = []

    case type
      when :name
        name_abb = self.name.mb_chars.split(' ')
        return self.name if name_abb.size < 3
        for i in 0..name_abb.size-2
          t = name_abb[i][0..0]
          name_abb[i] = t + '.' if t != t.downcase
        end

      when :name_reversed
        name_abb = self[:name_reversed].mb_chars.split(' ')
        return self[:name_reversed] if name_abb.size < 2
        name_abb[0] += ','
        for i in 2..name_abb.size-1
          t = name_abb[i].mb_chars[0..0]
          name_abb[i] = t + '.' if t != t.downcase
        end
    end

    name_abb.join(' ')
  end
end
