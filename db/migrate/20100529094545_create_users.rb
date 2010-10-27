class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.string :username, :null => false
      t.string :email, :null => false
      t.string :crypted_password, :null => false
      t.string :password_salt, :null => false

      t.string :persistence_token
      t.string :perishable_token
      t.datetime :last_request_at
      t.integer :failed_login_count, :default => 0, :null => false

      t.boolean :active, :default => false, :null => false
      t.boolean :admin, :default => false, :null => false
      
      t.timestamps
    end

    u = User.new
    u.username = 'admin'
    u.password = 'password'
    u.password_confirmation = 'password'
    u.email = 'admins_cannot_have_mail@nothing.nnn'
    u.active = true
    u.admin = true
    u.save(false)

  end
  
  def self.down
    drop_table :users
  end
end
