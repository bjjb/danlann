class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles, :force => true do |t|
      t.string :name, :null => false
      t.text :description

      t.timestamps
    end

    create_table :roles_users, :force => true, :primary_key => false do |t|
      t.belongs_to :user, :null => false
      t.belongs_to :role, :null => false
    end

    add_index :roles_users, [:user_id, :role_id], :unique => true
  end

  def self.down
    drop_table :roles_users
    drop_table :roles
  end
end
