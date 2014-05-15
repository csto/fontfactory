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

ActiveRecord::Schema.define(version: 20140510045657) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "characters", force: true do |t|
    t.integer  "font_id"
    t.string   "unicode"
    t.string   "character"
    t.string   "decimal"
    t.string   "name"
    t.text     "paths"
    t.text     "relative_paths"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fonts", force: true do |t|
    t.string   "name",          default: "New Font"
    t.integer  "grid",          default: 100
    t.integer  "x_height",      default: 400
    t.integer  "overshoot",     default: 10
    t.integer  "ascent_height", default: 700
    t.integer  "line_gap",      default: 250
    t.text     "characters",    default: "[{\"unicode\":\"0x20\",\"character\":\" \",\"decimal\":\"\\u0026#32;\",\"name\":\"Space\"},{\"unicode\":\"0x21\",\"character\":\"!\",\"decimal\":\"\\u0026#33;\",\"name\":\"Exclamation mark\\t\"},{\"unicode\":\"0x22\",\"character\":\"\\\"\",\"decimal\":\"\\u0026#34;\",\"name\":\"Quotation mark\\t\"},{\"unicode\":\"0x23\",\"character\":\"#\",\"decimal\":\"\\u0026#35;\",\"name\":\"Number sign, Hash tag\\t\"},{\"unicode\":\"0x24\",\"character\":\"$\",\"decimal\":\"\\u0026#36;\",\"name\":\"Dollar sign\\t\"},{\"unicode\":\"0x25\",\"character\":\"%\",\"decimal\":\"\\u0026#37;\",\"name\":\"Percent sign\\t\"},{\"unicode\":\"0x26\",\"character\":\"\\u0026\",\"decimal\":\"\\u0026#38;\",\"name\":\"Ampersand\\t\"},{\"unicode\":\"0x27\",\"character\":\"''\",\"decimal\":\"\\u0026#39;\",\"name\":\"Apostrophe\\t\"},{\"unicode\":\"0x28\",\"character\":\"(\",\"decimal\":\"\\u0026#40;\",\"name\":\"Left parenthesis\\t\"},{\"unicode\":\"0x29\",\"character\":\")\",\"decimal\":\"\\u0026#41;\",\"name\":\"Right parenthesis\\t\"},{\"unicode\":\"0x2A\",\"character\":\"*\",\"decimal\":\"\\u0026#42;\",\"name\":\"Asterisk\\t\"},{\"unicode\":\"0x2B\",\"character\":\"+\",\"decimal\":\"\\u0026#43;\",\"name\":\"Plus sign\\t\"},{\"unicode\":\"0x2C\",\"character\":\",\",\"decimal\":\"\\u0026#44;\",\"name\":\"Comma\\t\"},{\"unicode\":\"0x2D\",\"character\":\"-\",\"decimal\":\"\\u0026#45;\",\"name\":\"Hyphen-minus\\t\"},{\"unicode\":\"0x2E\",\"character\":\".\",\"decimal\":\"\\u0026#46;\",\"name\":\"Full stop\\t\"},{\"unicode\":\"0x2F\",\"character\":\"/\",\"decimal\":\"\\u0026#47;\",\"name\":\"Slash (Solidus)\\t\"},{\"unicode\":\"0x30\",\"character\":\"0\",\"decimal\":\"\\u0026#48;\",\"name\":\"Digit Zero\\t\"},{\"unicode\":\"0x31\",\"character\":\"1\",\"decimal\":\"\\u0026#49;\",\"name\":\"Digit One\\t\"},{\"unicode\":\"0x32\",\"character\":\"2\",\"decimal\":\"\\u0026#50;\",\"name\":\"Digit Two\\t\"},{\"unicode\":\"0x33\",\"character\":\"3\",\"decimal\":\"\\u0026#51;\",\"name\":\"Digit Three\\t\"},{\"unicode\":\"0x34\",\"character\":\"4\",\"decimal\":\"\\u0026#52;\",\"name\":\"Digit Four\\t\"},{\"unicode\":\"0x35\",\"character\":\"5\",\"decimal\":\"\\u0026#53;\",\"name\":\"Digit Five\\t\"},{\"unicode\":\"0x36\",\"character\":\"6\",\"decimal\":\"\\u0026#54;\",\"name\":\"Digit Six\\t\"},{\"unicode\":\"0x37\",\"character\":\"7\",\"decimal\":\"\\u0026#55;\",\"name\":\"Digit Seven\\t\"},{\"unicode\":\"0x38\",\"character\":\"8\",\"decimal\":\"\\u0026#56;\",\"name\":\"Digit Eight\\t\"},{\"unicode\":\"0x39\",\"character\":\"9\",\"decimal\":\"\\u0026#57;\",\"name\":\"Digit Nine\\t\"},{\"unicode\":\"0x3A\",\"character\":\":\",\"decimal\":\"\\u0026#58;\",\"name\":\"Colon\\t\"},{\"unicode\":\"0x3B\",\"character\":\";\",\"decimal\":\"\\u0026#59;\",\"name\":\"Semicolon\\t\"},{\"unicode\":\"0x3C\",\"character\":\"\\u003C\",\"decimal\":\"\\u0026#60;\",\"name\":\"Less-than sign\\t\"},{\"unicode\":\"0x3D\",\"character\":\"=\",\"decimal\":\"\\u0026#61;\",\"name\":\"Equal sign\\t\"},{\"unicode\":\"0x3E\",\"character\":\"\\u003E\",\"decimal\":\"\\u0026#62;\",\"name\":\"Greater-than sign\\t\"},{\"unicode\":\"0x3F\",\"character\":\"?\",\"decimal\":\"\\u0026#63;\",\"name\":\"Question mark\\t\"},{\"unicode\":\"0x40\",\"character\":\"@\",\"decimal\":\"\\u0026#64;\",\"name\":\"At sign\\t\"},{\"unicode\":\"0x41\",\"character\":\"A\",\"decimal\":\"\\u0026#65;\",\"name\":\"Latin Capital letter A\\t\"},{\"unicode\":\"0x42\",\"character\":\"B\",\"decimal\":\"\\u0026#66;\",\"name\":\"Latin Capital letter B\\t\"},{\"unicode\":\"0x43\",\"character\":\"C\",\"decimal\":\"\\u0026#67;\",\"name\":\"Latin Capital letter C\\t\"},{\"unicode\":\"0x44\",\"character\":\"D\",\"decimal\":\"\\u0026#68;\",\"name\":\"Latin Capital letter D\\t\"},{\"unicode\":\"0x45\",\"character\":\"E\",\"decimal\":\"\\u0026#69;\",\"name\":\"Latin Capital letter E\\t\"},{\"unicode\":\"0x46\",\"character\":\"F\",\"decimal\":\"\\u0026#70;\",\"name\":\"Latin Capital letter F\\t\"},{\"unicode\":\"0x47\",\"character\":\"G\",\"decimal\":\"\\u0026#71;\",\"name\":\"Latin Capital letter G\\t\"},{\"unicode\":\"0x48\",\"character\":\"H\",\"decimal\":\"\\u0026#72;\",\"name\":\"Latin Capital letter H\\t\"},{\"unicode\":\"0x49\",\"character\":\"I\",\"decimal\":\"\\u0026#73;\",\"name\":\"Latin Capital letter I\\t\"},{\"unicode\":\"0x4A\",\"character\":\"J\",\"decimal\":\"\\u0026#74;\",\"name\":\"Latin Capital letter J\\t\"},{\"unicode\":\"0x4B\",\"character\":\"K\",\"decimal\":\"\\u0026#75;\",\"name\":\"Latin Capital letter K\\t\"},{\"unicode\":\"0x4C\",\"character\":\"L\",\"decimal\":\"\\u0026#76;\",\"name\":\"Latin Capital letter L\\t\"},{\"unicode\":\"0x4D\",\"character\":\"M\",\"decimal\":\"\\u0026#77;\",\"name\":\"Latin Capital letter M\\t\"},{\"unicode\":\"0x4E\",\"character\":\"N\",\"decimal\":\"\\u0026#78;\",\"name\":\"Latin Capital letter N\\t\"},{\"unicode\":\"0x4F\",\"character\":\"O\",\"decimal\":\"\\u0026#79;\",\"name\":\"Latin Capital letter O\\t\"},{\"unicode\":\"0x50\",\"character\":\"P\",\"decimal\":\"\\u0026#80;\",\"name\":\"Latin Capital letter P\\t\"},{\"unicode\":\"0x51\",\"character\":\"Q\",\"decimal\":\"\\u0026#81;\",\"name\":\"Latin Capital letter Q\\t\"},{\"unicode\":\"0x52\",\"character\":\"R\",\"decimal\":\"\\u0026#82;\",\"name\":\"Latin Capital letter R\\t\"},{\"unicode\":\"0x53\",\"character\":\"S\",\"decimal\":\"\\u0026#83;\",\"name\":\"Latin Capital letter S\\t\"},{\"unicode\":\"0x54\",\"character\":\"T\",\"decimal\":\"\\u0026#84;\",\"name\":\"Latin Capital letter T\\t\"},{\"unicode\":\"0x55\",\"character\":\"U\",\"decimal\":\"\\u0026#85;\",\"name\":\"Latin Capital letter U\\t\"},{\"unicode\":\"0x56\",\"character\":\"V\",\"decimal\":\"\\u0026#86;\",\"name\":\"Latin Capital letter V\\t\"},{\"unicode\":\"0x57\",\"character\":\"W\",\"decimal\":\"\\u0026#87;\",\"name\":\"Latin Capital letter W\\t\"},{\"unicode\":\"0x58\",\"character\":\"X\",\"decimal\":\"\\u0026#88;\",\"name\":\"Latin Capital letter X\\t\"},{\"unicode\":\"0x59\",\"character\":\"Y\",\"decimal\":\"\\u0026#89;\",\"name\":\"Latin Capital letter Y\\t\"},{\"unicode\":\"0x5A\",\"character\":\"Z\",\"decimal\":\"\\u0026#90;\",\"name\":\"Latin Capital letter Z\\t\"},{\"unicode\":\"0x5B\",\"character\":\"[\",\"decimal\":\"\\u0026#91;\",\"name\":\"Left Square Bracket\\t\"},{\"unicode\":\"0x5C\",\"character\":\"\\\\\",\"decimal\":\"\\u0026#92;\",\"name\":\"Backslash\\t\"},{\"unicode\":\"0x5D\",\"character\":\"]\",\"decimal\":\"\\u0026#93;\",\"name\":\"Right Square Bracket\\t\"},{\"unicode\":\"0x5E\",\"character\":\"^\",\"decimal\":\"\\u0026#94;\",\"name\":\"Circumflex accent\\t\"},{\"unicode\":\"0x5F\",\"character\":\"_\",\"decimal\":\"\\u0026#95;\",\"name\":\"Low line\\t\"},{\"unicode\":\"0x60\",\"character\":\"`\",\"decimal\":\"\\u0026#96;\",\"name\":\"Grave accent\\t\"},{\"unicode\":\"0x61\",\"character\":\"a\",\"decimal\":\"\\u0026#97;\",\"name\":\"Latin Small Letter A\\t\"},{\"unicode\":\"0x62\",\"character\":\"b\",\"decimal\":\"\\u0026#98;\",\"name\":\"Latin Small Letter B\\t\"},{\"unicode\":\"0x63\",\"character\":\"c\",\"decimal\":\"\\u0026#99;\",\"name\":\"Latin Small Letter C\\t\"},{\"unicode\":\"0x64\",\"character\":\"d\",\"decimal\":\"\\u0026#100;\",\"name\":\"Latin Small Letter D\\t\"},{\"unicode\":\"0x65\",\"character\":\"e\",\"decimal\":\"\\u0026#101;\",\"name\":\"Latin Small Letter E\\t\"},{\"unicode\":\"0x66\",\"character\":\"f\",\"decimal\":\"\\u0026#102;\",\"name\":\"Latin Small Letter F\\t\"},{\"unicode\":\"0x67\",\"character\":\"g\",\"decimal\":\"\\u0026#103;\",\"name\":\"Latin Small Letter G\\t\"},{\"unicode\":\"0x68\",\"character\":\"h\",\"decimal\":\"\\u0026#104;\",\"name\":\"Latin Small Letter H\\t\"},{\"unicode\":\"0x69\",\"character\":\"i\",\"decimal\":\"\\u0026#105;\",\"name\":\"Latin Small Letter I\\t\"},{\"unicode\":\"0x6A\",\"character\":\"j\",\"decimal\":\"\\u0026#106;\",\"name\":\"Latin Small Letter J\\t\"},{\"unicode\":\"0x6B\",\"character\":\"k\",\"decimal\":\"\\u0026#107;\",\"name\":\"Latin Small Letter K\\t\"},{\"unicode\":\"0x6C\",\"character\":\"l\",\"decimal\":\"\\u0026#108;\",\"name\":\"Latin Small Letter L\\t\"},{\"unicode\":\"0x6D\",\"character\":\"m\",\"decimal\":\"\\u0026#109;\",\"name\":\"Latin Small Letter M\\t\"},{\"unicode\":\"0x6E\",\"character\":\"n\",\"decimal\":\"\\u0026#110;\",\"name\":\"Latin Small Letter N\\t\"},{\"unicode\":\"0x6F\",\"character\":\"o\",\"decimal\":\"\\u0026#111;\",\"name\":\"Latin Small Letter O\\t\"},{\"unicode\":\"0x70\",\"character\":\"p\",\"decimal\":\"\\u0026#112;\",\"name\":\"Latin Small Letter P\\t\"},{\"unicode\":\"0x71\",\"character\":\"q\",\"decimal\":\"\\u0026#113;\",\"name\":\"Latin Small Letter Q\\t\"},{\"unicode\":\"0x72\",\"character\":\"r\",\"decimal\":\"\\u0026#114;\",\"name\":\"Latin Small Letter R\\t\"},{\"unicode\":\"0x73\",\"character\":\"s\",\"decimal\":\"\\u0026#115;\",\"name\":\"Latin Small Letter S\\t\"},{\"unicode\":\"0x74\",\"character\":\"t\",\"decimal\":\"\\u0026#116;\",\"name\":\"Latin Small Letter T\\t\"},{\"unicode\":\"0x75\",\"character\":\"u\",\"decimal\":\"\\u0026#117;\",\"name\":\"Latin Small Letter U\\t\"},{\"unicode\":\"0x76\",\"character\":\"v\",\"decimal\":\"\\u0026#118;\",\"name\":\"Latin Small Letter V\\t\"},{\"unicode\":\"0x77\",\"character\":\"w\",\"decimal\":\"\\u0026#119;\",\"name\":\"Latin Small Letter W\\t\"},{\"unicode\":\"0x78\",\"character\":\"x\",\"decimal\":\"\\u0026#120;\",\"name\":\"Latin Small Letter X\\t\"},{\"unicode\":\"0x79\",\"character\":\"y\",\"decimal\":\"\\u0026#121;\",\"name\":\"Latin Small Letter Y\\t\"},{\"unicode\":\"0x7A\",\"character\":\"z\",\"decimal\":\"\\u0026#122;\",\"name\":\"Latin Small Letter Z\\t\"},{\"unicode\":\"0x7B\",\"character\":\"{\",\"decimal\":\"\\u0026#123;\",\"name\":\"Left Curly Bracket\\t\"},{\"unicode\":\"0x7C\",\"character\":\"|\",\"decimal\":\"\\u0026#124;\",\"name\":\"Vertical bar\\t\"},{\"unicode\":\"0x7D\",\"character\":\"}\",\"decimal\":\"\\u0026#125;\",\"name\":\"Right Curly Bracket\\t\"},{\"unicode\":\"0x7E\",\"character\":\"~\",\"decimal\":\"\\u0026#126;\",\"name\":\"Tilde\\t\"},{\"unicode\":\"0x7F\",\"character\":\"\u007F\",\"decimal\":\"\\u0026#127;\",\"name\":\"Delete\"}]"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "fonts", ["user_id"], name: "index_fonts_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "guest"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["guest"], name: "index_users_on_guest", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
