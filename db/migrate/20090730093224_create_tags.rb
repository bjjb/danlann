class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags, :force => true do |t|
      t.string :name, :null => false
      t.timestamps
    end
    add_index :tags, :name, :unique => true

    create_table :pictures_tags, :id => false, :force => true do |t|
      t.belongs_to :tag, :null => false
      t.belongs_to :picture, :null => false
    end
    add_index :pictures_tags, %w(tag_id picture_id), :unique => true
  end

  def self.down
    drop_table :pictures_tags
    drop_table :tags
  end
end
