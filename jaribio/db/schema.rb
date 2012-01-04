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

ActiveRecord::Schema.define(:version => 20120104172211) do

  create_table "executions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",      :null => false
    t.integer  "status_code",  :null => false
    t.string   "environment"
    t.text     "results"
    t.integer  "test_case_id", :null => false
    t.integer  "plan_id",      :null => false
  end

  add_index "executions", ["plan_id", "test_case_id"], :name => "index_executions_on_plan_id_and_test_case_id"
  add_index "executions", ["test_case_id"], :name => "executions_test_case_id_fk"
  add_index "executions", ["user_id"], :name => "executions_user_id_fk"

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
  add_index "plans", ["user_id"], :name => "plans_user_id_fk"

  create_table "plans_suites", :id => false, :force => true do |t|
    t.integer "plan_id",  :null => false
    t.integer "suite_id", :null => false
  end

  add_index "plans_suites", ["plan_id"], :name => "plans_suites_plan_id_fk"
  add_index "plans_suites", ["suite_id"], :name => "plans_suites_suite_id_fk"

  create_table "pre_steps", :force => true do |t|
    t.string   "name"
    t.text     "list"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pre_steps", ["name"], :name => "index_pre_steps_on_name", :unique => true

  create_table "steps", :force => true do |t|
    t.string   "action"
    t.string   "results"
    t.integer  "test_case_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort_order",   :null => false
  end

  add_index "steps", ["sort_order"], :name => "index_steps_on_sort_order"
  add_index "steps", ["test_case_id", "sort_order"], :name => "index_steps_on_test_case_id_and_sort_order", :unique => true

  create_table "suites", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "suites", ["name"], :name => "index_suites_on_name", :unique => true
  add_index "suites", ["user_id"], :name => "suites_user_id_fk"

  create_table "suites_test_cases", :force => true do |t|
    t.integer "test_case_id", :null => false
    t.integer "suite_id",     :null => false
    t.integer "sort_order"
  end

  add_index "suites_test_cases", ["sort_order"], :name => "index_suites_test_cases_on_sort_order"
  add_index "suites_test_cases", ["suite_id", "test_case_id"], :name => "index_suites_test_cases_on_suite_id_and_test_case_id"
  add_index "suites_test_cases", ["test_case_id"], :name => "suites_test_cases_test_case_id_fk"

  create_table "test_cases", :force => true do |t|
    t.integer  "user_id",                         :null => false
    t.text     "text",                            :null => false
    t.text     "expectations",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                            :null => false
    t.string   "unique_key",                      :null => false
    t.boolean  "automated",    :default => false, :null => false
  end

  add_index "test_cases", ["name"], :name => "index_test_cases_on_name"
  add_index "test_cases", ["unique_key"], :name => "index_test_cases_on_unique_key", :unique => true
  add_index "test_cases", ["user_id"], :name => "test_cases_user_id_fk"

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

  add_foreign_key "executions", "plans", :name => "executions_plan_id_fk", :dependent => :delete
  add_foreign_key "executions", "test_cases", :name => "executions_test_case_id_fk", :dependent => :delete
  add_foreign_key "executions", "users", :name => "executions_user_id_fk"

  add_foreign_key "plans", "users", :name => "plans_user_id_fk"

  add_foreign_key "plans_suites", "plans", :name => "plans_suites_plan_id_fk", :dependent => :delete
  add_foreign_key "plans_suites", "suites", :name => "plans_suites_suite_id_fk", :dependent => :delete

  add_foreign_key "steps", "test_cases", :name => "steps_test_case_id_fk", :dependent => :delete

  add_foreign_key "suites", "users", :name => "suites_user_id_fk"

  add_foreign_key "suites_test_cases", "suites", :name => "suites_test_cases_suite_id_fk", :dependent => :delete
  add_foreign_key "suites_test_cases", "test_cases", :name => "suites_test_cases_test_case_id_fk", :dependent => :delete

  add_foreign_key "test_cases", "users", :name => "test_cases_user_id_fk"

end
