require 'bundler/setup'
require 'dotenv/load'
require 'open-uri'
require 'net/http'
require 'json'
Bundler.require

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: "db/development.sqlite3"
)

ActiveRecord::Base.logger = Logger.new(STDOUT)

require_all 'app'
