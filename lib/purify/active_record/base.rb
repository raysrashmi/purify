module Purify
  module ActiveRecord
    module Base
      def self.extended(base)
        base.class_eval do
          def self.search(params)
            Search.new(self, params)
          end
        end
      end
    end
  end
end
