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

ActiveRecord::Schema.define(:version => 20090804185907) do

  create_table "batch_memberships", :force => true do |t|
    t.integer  "batch_id",                  :null => false
    t.integer  "picture_id",                :null => false
    t.integer  "position",   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "batch_memberships", ["batch_id", "picture_id"], :name => "index_batch_memberships_on_batch_id_and_picture_id", :unique => true

  create_table "batches", :force => true do |t|
    t.string   "name",                                      :null => false
    t.text     "description", :default => "No description", :null => false
    t.integer  "user_id",                                   :null => false
    t.string   "filename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "batches", ["name", "user_id"], :name => "index_batches_on_name_and_user_id", :unique => true

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "pictures", :force => true do |t|
    t.string   "image_filename", :null => false
    t.integer  "image_width",    :null => false
    t.integer  "image_height",   :null => false
    t.string   "name",           :null => false
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name",        :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :force => true do |t|
    t.integer "user_id", :null => false
    t.integer "role_id", :null => false
  end

  add_index "roles_users", ["user_id", "role_id"], :name => "index_roles_users_on_user_id_and_role_id", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id",     :null => false
    t.integer  "picture_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["tag_id", "picture_id"], :name => "index_taggings_on_tag_id_and_picture_id", :unique => true

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
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "openid_identifier"
    t.boolean  "administrator",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
