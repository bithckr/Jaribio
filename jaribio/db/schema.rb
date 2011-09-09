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

ActiveRecord::Schema.define(:version => 20110909005650) do

  create_table "executions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "executable_id",   :null => false
    t.string   "executable_type", :null => false
    t.integer  "user_id",         :null => false
    t.integer  "status_code",     :null => false
    t.string   "environment"
    t.text     "results"
  end

  create_table "issues", :force => true do |t|
    t.string "name", :null => false
    t.string "url",  :null => false
  end

  add_index "issues", ["name"], :name => "index_issues_on_name"
  add_index "issues", ["url"], :name => "index_issues_on_url"

  create_table "issues_suites", :id => false, :force => true do |t|
    t.integer "issue_id", :null => false
    t.integer "suite_id", :null => false
  end

  create_table "plans", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plans", ["name"], :name => "index_plans_on_name"

  create_table "plans_suites", :id => false, :force => true do |t|
    t.integer "plan_id",  :null => false
    t.integer "suite_id", :null => false
  end

  create_table "suites", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "suites", ["name"], :name => "index_suites_on_name"

  create_table "suites_test_cases", :id => false, :force => true do |t|
    t.integer "test_case_id", :null => false
    t.integer "suite_id",     :null => false
  end

  create_table "test_cases", :force => true do |t|
    t.integer  "user_id",      :null => false
    t.text     "text",         :null => false
    t.text     "expectations", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",         :null => false
  end

  add_index "test_cases", ["name"], :name => "index_test_cases_on_name"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
