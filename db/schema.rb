# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090730093224) do

  create_table "pictures", :force => true do |t|
    t.string   "image_filename",                   :null => false
    t.integer  "image_width",                      :null => false
    t.integer  "image_height",                     :null => false
    t.string   "name",                             :null => false
    t.text     "description"
    t.boolean  "public",         :default => true
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pictures_tags", :id => false, :force => true do |t|
    t.integer "tag_id",     :null => false
    t.integer "picture_id", :null => false
  end

  add_index "pictures_tags", ["tag_id", "picture_id"], :name => "index_pictures_tags_on_tag_id_and_picture_id", :unique => true

  create_table "tags", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                                  :null => false
    t.string   "crypted_password",                       :null => false
    t.string   "password_salt",                          :null => false
    t.string   "perishable_token"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "active",              :default => true
    t.boolean  "confirmed",           :default => false
    t.boolean  "administrator",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
