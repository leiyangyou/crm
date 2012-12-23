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

ActiveRecord::Schema.define(:version => 20121223110402) do

  create_table "account_contacts", :force => true do |t|
    t.integer  "account_id"
    t.integer  "contact_id"
    t.datetime "deleted_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "account_opportunities", :force => true do |t|
    t.integer  "account_id"
    t.integer  "opportunity_id"
    t.datetime "deleted_at"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "account_surveys", :force => true do |t|
    t.integer  "account_id"
    t.integer  "survey_id"
    t.integer  "response_set_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "account_surveys", ["account_id", "survey_id"], :name => "index_account_surveys_on_account_id_and_survey_id", :unique => true
  add_index "account_surveys", ["account_id"], :name => "index_account_surveys_on_account_id"
  add_index "account_surveys", ["response_set_id"], :name => "index_account_surveys_on_response_set_id"
  add_index "account_surveys", ["survey_id"], :name => "index_account_surveys_on_survey_id"

  create_table "account_visits", :force => true do |t|
    t.integer  "account_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "account_visits", ["account_id"], :name => "index_account_visits_on_account_id"

  create_table "accounts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "assigned_to"
    t.string   "name",                :limit => 64, :default => "",       :null => false
    t.string   "access",              :limit => 8,  :default => "Public"
    t.string   "website",             :limit => 64
    t.string   "toll_free_phone",     :limit => 32
    t.string   "phone",               :limit => 32
    t.string   "fax",                 :limit => 32
    t.datetime "deleted_at"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.string   "email",               :limit => 64
    t.string   "background_info"
    t.integer  "rating",                            :default => 0,        :null => false
    t.string   "category",            :limit => 32
    t.text     "subscribed_users"
    t.integer  "trainer_id"
    t.integer  "gender"
    t.string   "nationality"
    t.string   "identification"
    t.date     "dob"
    t.string   "work_phone"
    t.string   "emergency_contact_1"
    t.string   "emergency_contact_2"
    t.string   "card_number"
    t.string   "company"
    t.string   "street1"
    t.string   "street2"
    t.string   "zipcode"
    t.integer  "lead_id"
  end

  add_index "accounts", ["assigned_to"], :name => "index_accounts_on_assigned_to"
  add_index "accounts", ["card_number"], :name => "index_accounts_on_card_number"
  add_index "accounts", ["lead_id"], :name => "index_accounts_on_lead_id"
  add_index "accounts", ["trainer_id"], :name => "index_accounts_on_trainer_id"
  add_index "accounts", ["user_id", "name", "deleted_at"], :name => "index_accounts_on_user_id_and_name_and_deleted_at", :unique => true

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.string   "action",       :limit => 32, :default => "created"
    t.string   "info",                       :default => ""
    t.boolean  "private",                    :default => false
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  add_index "activities", ["created_at"], :name => "index_activities_on_created_at"
  add_index "activities", ["user_id"], :name => "index_activities_on_user_id"

  create_table "addresses", :force => true do |t|
    t.string   "street1"
    t.string   "street2"
    t.string   "city",             :limit => 64
    t.string   "state",            :limit => 64
    t.string   "zipcode",          :limit => 16
    t.string   "country",          :limit => 64
    t.string   "full_address"
    t.string   "address_type",     :limit => 16
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.datetime "deleted_at"
  end

  add_index "addresses", ["addressable_id", "addressable_type"], :name => "index_addresses_on_addressable_id_and_addressable_type"

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.text     "text"
    t.text     "short_text"
    t.text     "help_text"
    t.integer  "weight"
    t.string   "response_class"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.boolean  "is_exclusive"
    t.integer  "display_length"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "default_value"
    t.string   "api_id"
    t.string   "display_type"
  end

  create_table "appointments", :force => true do |t|
    t.integer  "daily_schedule_id"
    t.date     "date"
    t.time     "started_at"
    t.time     "finished_at"
    t.string   "status"
    t.string   "content"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "appointments", ["daily_schedule_id"], :name => "index_appointments_on_daily_schedule_id"

  create_table "assignments", :force => true do |t|
    t.integer  "assignable_id"
    t.string   "assignable_type"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "assignments", ["assignable_id", "assignable_type"], :name => "index_assignments_on_assignable_id_and_assignable_type"
  add_index "assignments", ["user_id"], :name => "index_assignments_on_user_id"

  create_table "avatars", :force => true do |t|
    t.integer  "user_id"
    t.integer  "entity_id"
    t.string   "entity_type"
    t.integer  "image_file_size"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "campaigns", :force => true do |t|
    t.integer  "user_id"
    t.integer  "assigned_to"
    t.string   "name",                :limit => 64,                                :default => "",       :null => false
    t.string   "access",              :limit => 8,                                 :default => "Public"
    t.string   "status",              :limit => 64
    t.decimal  "budget",                            :precision => 12, :scale => 2
    t.integer  "target_leads"
    t.float    "target_conversion"
    t.decimal  "target_revenue",                    :precision => 12, :scale => 2
    t.integer  "leads_count"
    t.integer  "opportunities_count"
    t.decimal  "revenue",                           :precision => 12, :scale => 2
    t.date     "starts_on"
    t.date     "ends_on"
    t.text     "objectives"
    t.datetime "deleted_at"
    t.datetime "created_at",                                                                             :null => false
    t.datetime "updated_at",                                                                             :null => false
    t.string   "background_info"
    t.text     "subscribed_users"
  end

  add_index "campaigns", ["assigned_to"], :name => "index_campaigns_on_assigned_to"
  add_index "campaigns", ["user_id", "name", "deleted_at"], :name => "index_campaigns_on_user_id_and_name_and_deleted_at", :unique => true

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.boolean  "private"
    t.string   "title",                          :default => ""
    t.text     "comment"
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.string   "state",            :limit => 16, :default => "Expanded", :null => false
  end

  create_table "contact_opportunities", :force => true do |t|
    t.integer  "contact_id"
    t.integer  "opportunity_id"
    t.string   "role",           :limit => 32
    t.datetime "deleted_at"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "contacts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "lead_id"
    t.integer  "assigned_to"
    t.integer  "reports_to"
    t.string   "first_name",       :limit => 64,  :default => "",       :null => false
    t.string   "last_name",        :limit => 64,  :default => "",       :null => false
    t.string   "access",           :limit => 8,   :default => "Public"
    t.string   "title",            :limit => 64
    t.string   "department",       :limit => 64
    t.string   "source",           :limit => 32
    t.string   "email",            :limit => 64
    t.string   "alt_email",        :limit => 64
    t.string   "phone",            :limit => 32
    t.string   "mobile",           :limit => 32
    t.string   "fax",              :limit => 32
    t.string   "blog",             :limit => 128
    t.string   "linkedin",         :limit => 128
    t.string   "facebook",         :limit => 128
    t.string   "twitter",          :limit => 128
    t.date     "born_on"
    t.boolean  "do_not_call",                     :default => false,    :null => false
    t.datetime "deleted_at"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "background_info"
    t.string   "skype",            :limit => 128
    t.text     "subscribed_users"
  end

  add_index "contacts", ["assigned_to"], :name => "index_contacts_on_assigned_to"
  add_index "contacts", ["user_id", "last_name", "deleted_at"], :name => "id_last_name_deleted", :unique => true

  create_table "contract_templates", :force => true do |t|
    t.string   "contract_type"
    t.text     "template"
    t.text     "parameters"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "format"
  end

  add_index "contract_templates", ["contract_type"], :name => "index_contract_templates_on_contract_type"

  create_table "contracts", :force => true do |t|
    t.string   "contract_id"
    t.string   "type"
    t.integer  "contract_template_id"
    t.integer  "account_id"
    t.text     "content"
    t.text     "parameters"
    t.string   "status"
    t.date     "started_on"
    t.date     "finished_on"
    t.datetime "signed_at"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "abstract"
  end

  add_index "contracts", ["contract_id"], :name => "index_contracts_on_contract_id", :unique => true
  add_index "contracts", ["contract_template_id"], :name => "index_contracts_on_contract_template_id"
  add_index "contracts", ["type"], :name => "index_contracts_on_type"

  create_table "daily_schedules", :force => true do |t|
    t.integer  "schedule_id"
    t.date     "date"
    t.integer  "slots",        :limit => 8, :default => 0
    t.integer  "working_time", :limit => 8, :default => 0
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "daily_schedules", ["schedule_id"], :name => "index_daily_schedules_on_schedule_id"

  create_table "dependencies", :force => true do |t|
    t.integer  "question_id"
    t.integer  "question_group_id"
    t.string   "rule"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "dependency_conditions", :force => true do |t|
    t.integer  "dependency_id"
    t.string   "rule_key"
    t.integer  "question_id"
    t.string   "operator"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit"
    t.text     "text_value"
    t.string   "string_value"
    t.string   "response_other"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "emails", :force => true do |t|
    t.string   "imap_message_id",                                       :null => false
    t.integer  "user_id"
    t.integer  "mediator_id"
    t.string   "mediator_type"
    t.string   "sent_from",                                             :null => false
    t.string   "sent_to",                                               :null => false
    t.string   "cc"
    t.string   "bcc"
    t.string   "subject"
    t.text     "body"
    t.text     "header"
    t.datetime "sent_at"
    t.datetime "received_at"
    t.datetime "deleted_at"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "state",           :limit => 16, :default => "Expanded", :null => false
  end

  add_index "emails", ["mediator_id", "mediator_type"], :name => "index_emails_on_mediator_id_and_mediator_type"

  create_table "field_groups", :force => true do |t|
    t.string   "name",       :limit => 64
    t.string   "label",      :limit => 128
    t.integer  "position"
    t.string   "hint"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "tag_id"
    t.string   "klass_name", :limit => 32
  end

  create_table "fields", :force => true do |t|
    t.string   "type"
    t.integer  "field_group_id"
    t.integer  "position"
    t.string   "name",           :limit => 64
    t.string   "label",          :limit => 128
    t.string   "hint"
    t.string   "placeholder"
    t.string   "as",             :limit => 32
    t.text     "collection"
    t.boolean  "disabled"
    t.boolean  "required"
    t.integer  "maxlength"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "fields", ["field_group_id"], :name => "index_fields_on_field_group_id"
  add_index "fields", ["name"], :name => "index_fields_on_name"

  create_table "leads", :force => true do |t|
    t.integer  "user_id"
    t.integer  "campaign_id"
    t.integer  "assigned_to"
    t.string   "first_name",       :limit => 64,  :default => "",       :null => false
    t.string   "last_name",        :limit => 64,  :default => "",       :null => false
    t.string   "access",           :limit => 8,   :default => "Public"
    t.string   "title",            :limit => 64
    t.string   "company",          :limit => 64
    t.string   "source",           :limit => 32
    t.string   "status",           :limit => 32
    t.string   "referred_by",      :limit => 64
    t.string   "email",            :limit => 64
    t.string   "alt_email",        :limit => 64
    t.string   "phone",            :limit => 32
    t.string   "mobile",           :limit => 32
    t.string   "blog",             :limit => 128
    t.string   "linkedin",         :limit => 128
    t.string   "facebook",         :limit => 128
    t.string   "twitter",          :limit => 128
    t.integer  "rating",                          :default => 0,        :null => false
    t.boolean  "do_not_call",                     :default => false,    :null => false
    t.datetime "deleted_at"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "background_info"
    t.string   "skype",            :limit => 128
    t.text     "subscribed_users"
    t.integer  "gender"
  end

  add_index "leads", ["assigned_to"], :name => "index_leads_on_assigned_to"
  add_index "leads", ["user_id", "last_name", "deleted_at"], :name => "index_leads_on_user_id_and_last_name_and_deleted_at", :unique => true

  create_table "lessons", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "times"
    t.integer  "price"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "trainer_id"
  end

  add_index "lessons", ["trainer_id"], :name => "index_lessons_on_trainer_id"

  create_table "lists", :force => true do |t|
    t.string   "name"
    t.text     "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "locker_rents", :force => true do |t|
    t.integer  "locker_id"
    t.integer  "account_id"
    t.string   "contract_id"
    t.date     "start_date"
    t.date     "due_date"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "locker_rents", ["account_id"], :name => "index_locker_rents_on_account_id"
  add_index "locker_rents", ["locker_id"], :name => "index_locker_rents_on_locker_id"

  create_table "lockers", :force => true do |t|
    t.string   "identifier"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "lockers", ["identifier"], :name => "index_lockers_on_identifier", :unique => true

  create_table "membership_states", :force => true do |t|
    t.string   "state_type"
    t.string   "contract_id"
    t.integer  "last_state_id"
    t.integer  "membership_id"
    t.text     "parameters"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "membership_states", ["last_state_id"], :name => "index_membership_states_on_last_state_id"
  add_index "membership_states", ["membership_id"], :name => "index_membership_states_on_membership_id"

  create_table "membership_types", :force => true do |t|
    t.string   "name"
    t.integer  "duration"
    t.boolean  "transferable", :default => true
    t.boolean  "suspendable",  :default => true
    t.boolean  "terminatable", :default => true
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "price",        :default => 0
  end

  create_table "memberships", :force => true do |t|
    t.integer  "type_id"
    t.integer  "account_id"
    t.date     "started_on"
    t.date     "finished_on"
    t.integer  "duration",      :default => 0
    t.string   "status"
    t.string   "contract_id"
    t.integer  "consultant_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "memberships", ["account_id"], :name => "index_memberships_on_account_id"
  add_index "memberships", ["consultant_id"], :name => "index_memberships_on_consultant_id"
  add_index "memberships", ["status"], :name => "index_memberships_on_status"
  add_index "memberships", ["type_id"], :name => "index_memberships_on_type_id"

  create_table "opportunities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "campaign_id"
    t.integer  "assigned_to"
    t.string   "name",             :limit => 64,                                :default => "",       :null => false
    t.string   "access",           :limit => 8,                                 :default => "Public"
    t.string   "source",           :limit => 32
    t.string   "stage",            :limit => 32
    t.integer  "probability"
    t.decimal  "amount",                         :precision => 12, :scale => 2
    t.decimal  "discount",                       :precision => 12, :scale => 2
    t.date     "closes_on"
    t.datetime "deleted_at"
    t.datetime "created_at",                                                                          :null => false
    t.datetime "updated_at",                                                                          :null => false
    t.string   "background_info"
    t.text     "subscribed_users"
  end

  add_index "opportunities", ["assigned_to"], :name => "index_opportunities_on_assigned_to"
  add_index "opportunities", ["user_id", "name", "deleted_at"], :name => "id_name_deleted", :unique => true

  create_table "participations", :force => true do |t|
    t.integer  "account_id"
    t.integer  "lesson_id"
    t.integer  "trainer_id"
    t.integer  "times"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "contract_id"
  end

  add_index "participations", ["account_id"], :name => "index_participations_on_account_id"
  add_index "participations", ["lesson_id"], :name => "index_participations_on_lesson_id"
  add_index "participations", ["trainer_id"], :name => "index_participations_on_trainer_id"

  create_table "permissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "asset_id"
    t.string   "asset_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "permissions", ["asset_id", "asset_type"], :name => "index_permissions_on_asset_id_and_asset_type"
  add_index "permissions", ["user_id"], :name => "index_permissions_on_user_id"

  create_table "preferences", :force => true do |t|
    t.integer  "user_id"
    t.string   "name",       :limit => 32, :default => "", :null => false
    t.text     "value"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "preferences", ["user_id", "name"], :name => "index_preferences_on_user_id_and_name"

  create_table "question_groups", :force => true do |t|
    t.text     "text"
    t.text     "help_text"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.string   "display_type"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "api_id"
  end

  create_table "questions", :force => true do |t|
    t.integer  "survey_section_id"
    t.integer  "question_group_id"
    t.text     "text"
    t.text     "short_text"
    t.text     "help_text"
    t.string   "pick"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.string   "display_type"
    t.boolean  "is_mandatory"
    t.integer  "display_width"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.integer  "correct_answer_id"
    t.string   "api_id"
  end

  create_table "response_sets", :force => true do |t|
    t.integer  "user_id"
    t.integer  "survey_id"
    t.string   "access_code"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "api_id"
  end

  add_index "response_sets", ["access_code"], :name => "response_sets_ac_idx", :unique => true

  create_table "responses", :force => true do |t|
    t.integer  "response_set_id"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit"
    t.text     "text_value"
    t.string   "string_value"
    t.string   "response_other"
    t.string   "response_group"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "survey_section_id"
    t.string   "api_id"
  end

  add_index "responses", ["survey_section_id"], :name => "index_responses_on_survey_section_id"

  create_table "schedule_templates", :force => true do |t|
    t.string   "template_type"
    t.boolean  "is_default"
    t.text     "parameters"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "schedules", :force => true do |t|
    t.integer  "user_id"
    t.integer  "template_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "schedules", ["template_id"], :name => "index_schedules_on_template_id"
  add_index "schedules", ["user_id"], :name => "index_schedules_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.string   "name",       :limit => 32, :default => "", :null => false
    t.text     "value"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "settings", ["name"], :name => "index_settings_on_name"

  create_table "survey_sections", :force => true do |t|
    t.integer  "survey_id"
    t.string   "title"
    t.text     "description"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.string   "custom_class"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "surveys", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "access_code"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.datetime "active_at"
    t.datetime "inactive_at"
    t.string   "css_url"
    t.string   "custom_class"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.integer  "display_order"
    t.string   "api_id"
  end

  add_index "surveys", ["access_code"], :name => "surveys_ac_idx", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "tasks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "assigned_to"
    t.integer  "completed_by"
    t.string   "name",                           :default => "", :null => false
    t.integer  "asset_id"
    t.string   "asset_type"
    t.string   "priority",         :limit => 32
    t.string   "category",         :limit => 32
    t.string   "bucket",           :limit => 32
    t.datetime "due_at"
    t.datetime "completed_at"
    t.datetime "deleted_at"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.string   "background_info"
    t.text     "subscribed_users"
  end

  add_index "tasks", ["assigned_to"], :name => "index_tasks_on_assigned_to"
  add_index "tasks", ["user_id", "name", "deleted_at"], :name => "index_tasks_on_user_id_and_name_and_deleted_at", :unique => true

  create_table "user_daily_performances", :force => true do |t|
    t.time     "date"
    t.integer  "user_id"
    t.integer  "performance"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "type"
  end

  add_index "user_daily_performances", ["type"], :name => "index_user_daily_performances_on_type"
  add_index "user_daily_performances", ["user_id"], :name => "index_user_daily_performances_on_user_id"

  create_table "user_ranks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "rank",               :default => 99999
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "type"
    t.integer  "rank_override"
    t.integer  "weekly_performance"
  end

  add_index "user_ranks", ["type"], :name => "index_user_ranks_on_type"
  add_index "user_ranks", ["user_id"], :name => "index_user_ranks_on_user_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "username",            :limit => 32, :default => "",    :null => false
    t.string   "email",               :limit => 64, :default => "",    :null => false
    t.string   "first_name",          :limit => 32
    t.string   "last_name",           :limit => 32
    t.string   "title",               :limit => 64
    t.string   "company",             :limit => 64
    t.string   "alt_email",           :limit => 64
    t.string   "phone",               :limit => 32
    t.string   "mobile",              :limit => 32
    t.string   "aim",                 :limit => 32
    t.string   "yahoo",               :limit => 32
    t.string   "google",              :limit => 32
    t.string   "skype",               :limit => 32
    t.string   "password_hash",                     :default => "",    :null => false
    t.string   "password_salt",                     :default => "",    :null => false
    t.string   "persistence_token",                 :default => "",    :null => false
    t.string   "perishable_token",                  :default => "",    :null => false
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.integer  "login_count",                       :default => 0,     :null => false
    t.datetime "deleted_at"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.boolean  "admin",                             :default => false, :null => false
    t.datetime "suspended_at"
    t.string   "single_access_token"
    t.integer  "roles_mask",                        :default => 0
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"
  add_index "users", ["persistence_token"], :name => "index_users_on_remember_token"
  add_index "users", ["username", "deleted_at"], :name => "index_users_on_username_and_deleted_at", :unique => true

  create_table "validation_conditions", :force => true do |t|
    t.integer  "validation_id"
    t.string   "rule_key"
    t.string   "operator"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit"
    t.text     "text_value"
    t.string   "string_value"
    t.string   "response_other"
    t.string   "regexp"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "validations", :force => true do |t|
    t.integer  "answer_id"
    t.string   "rule"
    t.string   "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "versions", :force => true do |t|
    t.string   "item_type",      :null => false
    t.integer  "item_id",        :null => false
    t.string   "event",          :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.integer  "related_id"
    t.string   "related_type"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"
  add_index "versions", ["whodunnit"], :name => "index_versions_on_whodunnit"

end
