module Purify
  class SearchFieldException < SearchError
    attr_accessor :field, :value, :operator
    def initialize(keys = {})
      @field = keys[:search_field]
      @value = keys[:search_value]
      @operator = keys[:search_op]
    end

    def message
      if !@field.blank?
        "Unknown search field #{field}"
      elsif !@operator.empty?
        "Unknown search operator #{operator}"
      elsif !@value.empty?
        "Invalid field value #{value}"
      end
    end
  end
end
