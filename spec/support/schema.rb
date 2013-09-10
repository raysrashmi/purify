require 'active_record'
ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => ':memory:'
)

class User < ActiveRecord::Base
end

module Schema
  def self.create
    ActiveRecord::Base.silence do
      ActiveRecord::Migration.verbose = false
      ActiveRecord::Schema.define do
        create_table :users, :force => true do |t|
          t.string  :first_name
          t.string   :last_name
          t.string   :email
          t.timestamps
        end
      end
    end
    5.times do
      User.make
    end
  end
end

