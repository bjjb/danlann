class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|
      t.string :image_filename
      t.integer :image_width
      t.integer :image_height
      t.string :name
      t.text  :description
      t.boolean :public, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :pictures
  end
end
