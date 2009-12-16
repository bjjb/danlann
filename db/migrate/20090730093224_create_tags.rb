class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags, :force => true do |t|
      t.string :name, :null => false
      t.timestamps
    end
    add_index :tags, :name, :unique => true

    create_table :taggings, :force => true do |t|
      t.belongs_to :tag
      t.belongs_to :picture
      t.integer :position, :default => 1
      t.timestamps
    end
    add_index :taggings, [:tag_id, :picture_id], :uniq => true
  end

  def self.down
    remove_index :taggings, :column => [:tag_id, :picture_id]
    drop_table :taggings

    remove_index :tags, :column => :name
    drop_table :tags
  end
end
