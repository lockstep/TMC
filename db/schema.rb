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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170213142819) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "adjustments", force: :cascade do |t|
    t.integer  "order_id"
    t.float    "amount"
    t.integer  "promotion_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "adjustments", ["order_id"], name: "index_adjustments_on_order_id", using: :btree
  add_index "adjustments", ["promotion_id"], name: "index_adjustments_on_promotion_id", using: :btree

  create_table "alternate_language_products", id: false, force: :cascade do |t|
    t.integer "left_product_id",  null: false
    t.integer "right_product_id", null: false
  end

  create_table "certificate_acquisitions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "certification_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "certificate_acquisitions", ["user_id", "certification_id"], name: "index_certificate_acquisitions_on_user_id_and_certification_id", using: :btree

  create_table "certifications", force: :cascade do |t|
    t.string   "name"
    t.boolean  "public",     default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "charges", force: :cascade do |t|
    t.integer  "amount"
    t.integer  "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "email"
    t.string   "currency"
  end

  add_index "charges", ["order_id"], name: "index_charges_on_order_id", using: :btree

  create_table "downloadables", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  add_index "downloadables", ["product_id"], name: "index_downloadables_on_product_id", using: :btree

  create_table "explorable_locations", force: :cascade do |t|
    t.integer  "explorable_id"
    t.string   "explorable_type"
    t.integer  "visual_exploration_id"
    t.string   "label"
    t.float    "x"
    t.float    "y"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "explorable_locations", ["explorable_type", "explorable_id"], name: "index_explorable_locations_on_explorable_type_and_explorable_id", using: :btree
  add_index "explorable_locations", ["visual_exploration_id"], name: "index_explorable_locations_on_visual_exploration_id", using: :btree

  create_table "feed_items", force: :cascade do |t|
    t.string   "type"
    t.text     "message"
    t.integer  "feedable_id"
    t.string   "feedable_type"
    t.integer  "author_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "feed_items", ["author_id"], name: "index_feed_items_on_author_id", using: :btree
  add_index "feed_items", ["feedable_type", "feedable_id"], name: "index_feed_items_on_feedable_type_and_feedable_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.text     "caption"
    t.boolean  "primary",            default: false
    t.string   "s3_key"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "images", ["imageable_id", "imageable_type", "primary"], name: "index_images_on_imageable_id_and_imageable_type_and_primary", unique: true, where: "(\"primary\" = true)", using: :btree

  create_table "interests", force: :cascade do |t|
    t.string   "name"
    t.boolean  "public",     default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "slug"
  end

  add_index "interests", ["slug"], name: "index_interests_on_slug", unique: true, using: :btree

  create_table "line_items", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "order_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "shipping_cost_cents"
  end

  add_index "line_items", ["order_id"], name: "index_line_items_on_order_id", using: :btree
  add_index "line_items", ["product_id"], name: "index_line_items_on_product_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "state",      default: 0
    t.integer  "user_id"
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "personal_interests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "interest_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "personal_interests", ["user_id", "interest_id"], name: "index_personal_interests_on_user_id_and_interest_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "slug"
    t.integer  "user_id"
    t.string   "category"
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
  end

  add_index "posts", ["slug"], name: "index_posts_on_slug", unique: true, using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "presentations", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "topic_id"
    t.string   "summary"
    t.integer  "section",     default: 0
    t.string   "slug"
  end

  add_index "presentations", ["slug"], name: "index_presentations_on_slug", unique: true, using: :btree
  add_index "presentations", ["topic_id"], name: "index_presentations_on_topic_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.float    "price"
    t.string   "slug"
    t.boolean  "featured",                      default: false
    t.integer  "presentation_id"
    t.boolean  "free",                          default: false, null: false
    t.boolean  "live",                          default: false
    t.boolean  "fulfill_via_shipment",          default: false
    t.integer  "vendor_id"
    t.float    "weight"
    t.float    "length"
    t.float    "width"
    t.float    "height"
    t.integer  "min_shipping_cost_cents"
    t.integer  "max_shipping_cost_cents"
    t.text     "recommended_vendor_url"
    t.text     "recommended_budget_vendor_url"
    t.text     "purpose"
    t.text     "presentation_summary"
    t.text     "youtube_url"
    t.text     "external_resource_url"
    t.string   "show_cta_text"
    t.string   "list_cta_text"
    t.integer  "language",                      default: 0
  end

  add_index "products", ["presentation_id"], name: "index_products_on_presentation_id", using: :btree
  add_index "products", ["slug"], name: "index_products_on_slug", unique: true, using: :btree
  add_index "products", ["vendor_id"], name: "index_products_on_vendor_id", using: :btree

  create_table "products_topics", id: false, force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "topic_id",   null: false
  end

  add_index "products_topics", ["product_id", "topic_id"], name: "index_products_topics_on_product_id_and_topic_id", using: :btree
  add_index "products_topics", ["topic_id", "product_id"], name: "index_products_topics_on_topic_id_and_product_id", using: :btree

  create_table "promotions", force: :cascade do |t|
    t.string   "code"
    t.string   "description"
    t.datetime "starts_at"
    t.datetime "expires_at"
    t.integer  "percent"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "promotions", ["code"], name: "index_promotions_on_code", unique: true, using: :btree

  create_table "related_products", id: false, force: :cascade do |t|
    t.integer "left_product_id",  null: false
    t.integer "right_product_id", null: false
  end

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "parent_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "slug"
    t.integer  "position"
    t.integer  "visual_exploration_id"
    t.boolean  "force_subnavigation",   default: false
  end

  add_index "topics", ["parent_id"], name: "index_topics_on_parent_id", using: :btree
  add_index "topics", ["slug"], name: "index_topics_on_slug", unique: true, using: :btree
  add_index "topics", ["visual_exploration_id"], name: "index_topics_on_visual_exploration_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                        default: "",    null: false
    t.string   "encrypted_password",           default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "role"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.text     "bio"
    t.string   "address_line_one"
    t.string   "address_line_two"
    t.string   "address_city"
    t.string   "address_state"
    t.string   "address_postal_code"
    t.string   "address_country"
    t.string   "organization_name"
    t.string   "position"
    t.boolean  "bambini_pilot_participant",    default: false
    t.boolean  "opted_in_to_public_directory", default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "visual_explorations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "adjustments", "orders"
  add_foreign_key "adjustments", "promotions"
  add_foreign_key "charges", "orders"
  add_foreign_key "downloadables", "products"
  add_foreign_key "explorable_locations", "visual_explorations"
  add_foreign_key "identities", "users"
  add_foreign_key "line_items", "orders"
  add_foreign_key "line_items", "products"
  add_foreign_key "orders", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "presentations", "topics"
  add_foreign_key "products", "presentations"
  add_foreign_key "topics", "visual_explorations"
end
