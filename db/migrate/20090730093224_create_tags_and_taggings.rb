class CreateTagsAndTaggings < ActiveRecord::Migration
  def self.up
    create_table :tags, :force => true do |t|
      t.string :name, :null => false
      t.timestamps
    end
    add_index :tags, :name, :unique => true

    create_table :taggings, :force => true do |t|
      t.belongs_to :tag, :null => false
      t.belongs_to :picture, :null => false
      t.belongs_to :user, :null => false
      t.timestamps
    end
    add_index :taggings, %w(tag_id picture_id), :unique => true
  end

  def self.down
    drop_table :taggings
    drop_table :tags
  end
end
