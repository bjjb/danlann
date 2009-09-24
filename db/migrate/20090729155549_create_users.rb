class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email, :null => false
      t.string :crypted_password, :null => false
      t.string :password_salt, :null => false
      t.string :perishable_token
      t.string :persistence_token
      t.string :single_access_token
      t.integer :login_count
      t.integer :failed_login_count
      t.datetime :last_request_at
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string :current_login_ip
      t.string :last_login_ip
      t.boolean :active, :default => true
      t.boolean :confirmed, :default => false
      t.boolean :administrator, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
