class CreateBookAliases < ActiveRecord::Migration
  def self.up
    create_table :book_aliases, :options => 'default charset=utf8', :force => true do |t|
      t.string :title,    :null => false
      t.integer :letter,  :null => false, :default => 0
      t.references :book, :null => false
    end
  end

  def self.down
    drop_table :book_aliases
  end
end
