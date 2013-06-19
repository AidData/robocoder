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

ActiveRecord::Schema.define(:version => 20130618185208) do

  create_table "codes", :id => false, :force => true do |t|
    t.string   "name"
    t.integer  "number"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "codes_matches", :id => false, :force => true do |t|
    t.integer "code_id"
    t.integer "match_id"
  end

  create_table "codes_patterns", :id => false, :force => true do |t|
    t.integer "code_id"
    t.integer "pattern_id"
  end

  create_table "matches", :force => true do |t|
    t.string   "words"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.boolean  "unordered"
    t.boolean  "complete_text"
    t.boolean  "plural"
  end

  create_table "patterns", :force => true do |t|
    t.string   "regex"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
