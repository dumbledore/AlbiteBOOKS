class CreateTranslations < ActiveRecord::Migration
  def self.up
    create_table :translations, :options => 'default charset=utf8', :force => true do |t|
      t.integer :language, :null => false # number from AlbiteREADER's languages

      t.references :book, :null => false

#      t.string :url, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :translations
  end
end
