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

ActiveRecord::Schema.define(:version => 20130429075645) do

  create_table "bils", :force => true do |t|
    t.string   "issue_key"
    t.string   "issue_type"
    t.string   "summary"
    t.string   "version_id"
    t.string   "version_name"
    t.string   "priority"
    t.string   "assignee"
    t.string   "reporter"
    t.string   "status"
    t.text     "descript"
    t.string   "project_key"
    t.string   "project_id"
    t.string   "project_name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

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

  create_table "criterions", :force => true do |t|
    t.integer  "teaminfo_id"
    t.integer  "projectinfo_id"
    t.string   "status"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
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

  create_table "email_templates", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "subject"
  end

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
    t.string   "owner"
    t.integer  "component_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "people", :force => true do |t|
    t.string   "eid"
    t.string   "email"
    t.string   "sapname"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "lastname"
    t.string   "firstname"
    t.string   "orgunit"
    t.string   "ims"
  end

  create_table "positions", :force => true do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.integer  "teaminfo_id"
    t.integer  "projectinfo_id"
    t.integer  "taktinfo_id"
    t.integer  "testplan_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "projectinfos", :force => true do |t|
    t.string   "projectID"
    t.string   "description"
    t.string   "jira"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "role"
    t.string   "description"
    t.integer  "authority"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "taktinfos", :force => true do |t|
    t.string   "taktID"
    t.date     "start_time"
    t.date     "end_time"
    t.integer  "criterion_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "reporter"
  end

  create_table "teaminfos", :force => true do |t|
    t.string   "team_name"
    t.text     "description"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "qm"
    t.string   "po"
    t.string   "scrum_master"
    t.string   "sponsor_manager"
  end

  create_table "testplans", :force => true do |t|
    t.string   "plan_name"
    t.string   "test_type"
    t.string   "coverage"
    t.string   "ok_rate"
    t.string   "status"
    t.integer  "open_message"
    t.text     "comment"
    t.integer  "taktinfo_id"
    t.integer  "format"
    t.boolean  "automated"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "reporter"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "sap_name"
    t.string   "sap_id"
    t.string   "email_address"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
