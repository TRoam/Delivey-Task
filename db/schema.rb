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

ActiveRecord::Schema.define(:version => 20121224054536) do

  create_table "checkmen", :force => true do |t|
    t.string   "status",               :default => "open"
    t.date     "foundat"
    t.integer  "priority"
    t.string   "checkid"
    t.string   "messageid"
    t.string   "uniqueid"
    t.string   "release"
    t.boolean  "prodrel",              :default => false
    t.string   "dlm",                  :default => "Drik"
    t.string   "key"
    t.integer  "ncount"
    t.integer  "objectresponsible_id"
    t.string   "feedback",             :default => "open"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "checkman_id"
    t.string   "commenter"
    t.text     "content"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "components", :force => true do |t|
    t.string   "softwarecomponent"
    t.string   "applicationcomponent"
    t.text     "description"
    t.string   "original"
    t.string   "dev_comp_owner"
    t.string   "dev_product_owner"
    t.string   "ims_manager"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "objectresponsibles", :force => true do |t|
    t.string   "objectname"
    t.string   "objecttype"
    t.string   "contact",    :default => "SAP"
    t.integer  "person_id"
    t.integer  "package_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "packages", :force => true do |t|
    t.string   "package"
    t.integer  "component_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "people", :force => true do |t|
    t.string   "responsibleperson", :default => "SAP"
    t.integer  "eid"
    t.string   "email"
    t.string   "sapname"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

end
