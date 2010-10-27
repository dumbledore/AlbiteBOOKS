class CreateAliases < ActiveRecord::Migration
  def self.up
    create_table :aliases, :options => 'default charset=utf8', :force => true do |t|
      t.string :name_reversed, :null => false
      t.integer :letter, :null => false
      t.references :author, :null => false
    end
  end

  def self.down
  end
end
