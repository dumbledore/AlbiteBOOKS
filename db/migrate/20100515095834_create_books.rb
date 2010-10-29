class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books, :options => 'default charset=utf8', :force => true do |t|
      t.string  :title,  :null => false
      t.integer :letter, :null => false
      t.string  :freebase_uid,  :null => false
      t.string  :thumbnail_url, :null => false
                                              t
      # cache these values for the mobile version 
      t.text    :description, :null => false
      t.string  :date_of_first_publication, :null => false
      t.string  :original_language, :null => false
      t.integer :number_of_pages

      t.references :author, :null => false

      t.references :translation

      t.integer :downloads, :default => 0, :null => false

      t.boolean :ready, :null => false, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :books
  end
end
