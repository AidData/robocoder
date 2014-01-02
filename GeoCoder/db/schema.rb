# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130825163009) do

  create_table "activities", :force => true do |t|
    t.string   "identifier"
    t.string   "title"
    t.text     "description"
    t.string   "country"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "marker_color"
    t.string   "precision"
  end

  create_table "positions", :force => true do |t|
    t.decimal  "lat"
    t.decimal  "long"
    t.integer  "activity_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "keyword"
    t.text     "address"
  end

  add_index "positions", ["activity_id"], :name => "index_positions_on_activity_id"

end
