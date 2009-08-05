class CreateBatchesAndBatchMemberships < ActiveRecord::Migration
  def self.up
    create_table :batches, :force => true do |t|
      t.string :name, :null => false
      t.text :description, :null => false, :default => 'No description'
      t.belongs_to :user, :null => false
      t.string :filename
      t.timestamps
    end
    add_index :batches, %w(name user_id), :unique => true

    create_table :batch_memberships, :force => true do |t|
      t.belongs_to :batch, :null => false
      t.belongs_to :picture, :null => false
      t.integer :position, :default => 0
      t.timestamps
    end
    add_index :batch_memberships, %w(batch_id picture_id), :unique => true

  end

  def self.down
    drop_table :batch_memberships
    drop_table :batches
  end
end
