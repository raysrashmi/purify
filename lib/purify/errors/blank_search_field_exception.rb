module Purify
  class BlankSearchFieldException < SearchError
    attr_accessor :field
    def initialize(field)
      @field = field
    end

    def message
      "Invalid blank field #{field}"
    end
  end
end
