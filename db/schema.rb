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

ActiveRecord::Schema.define(:version => 20130502214100) do

  create_table "event_searches", :id => false, :force => true do |t|
    t.text     "json"
    t.string   "username"
    t.datetime "created_at",                                                                        :null => false
    t.datetime "updated_at",                                                                        :null => false
    t.string   "uuid",            :limit => 36, :default => "00000000-0000-0000-0000-000000000000", :null => false
    t.datetime "last_started_at"
  end

  add_index "event_searches", ["uuid"], :name => "index_event_searches_on_uuid", :unique => true

end
