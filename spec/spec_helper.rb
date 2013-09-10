require 'machinist/active_record'
require 'sham'
require 'faker'
require 'purify'

Dir[File.expand_path('../{support,blueprints}/*.rb', __FILE__)].each do |f|
  require f
end
Sham.define do
  first_name    { Faker::Name.first_name }
  last_name    { Faker::Name.last_name  }
  email     { Faker::Internet.email }
end

RSpec.configure do |config|
  config.before(:suite) do
    puts '=' * 80
    puts "Running specs against ActiveRecord #{ActiveRecord::VERSION::STRING} ..."
    puts '=' * 80
    Schema.create
  end
end

