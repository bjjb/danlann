class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|
      t.string :image_filename, :null => false
      t.integer :image_width, :null => false
      t.integer :image_height, :null => false
      t.string :name, :null => false
      t.text :description
      t.belongs_to :user
      t.timestamps
    end
  end

  def self.down
    drop_table :pictures
  end
end
