class CreateTranslations < ActiveRecord::Migration
  def self.up
    create_table :translations, :options => 'default charset=utf8', :force => true do |t|
      t.string   :note,     :null => false # add note (usually blank, but sometimes useful, e.g. Illustrated by R. Harris
      t.integer  :language, :null => false # see lib/languages.rb
      t.boolean  :original, :null => false, :default => true

      t.references :book, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :translations
  end
end
