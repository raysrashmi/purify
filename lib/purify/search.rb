require 'purify/errors/search_error'
require 'purify/errors/blank_search_field_exception'
require 'purify/errors/search_field_exception'

module Purify
  class Search

    OPERATORS = {contains: {name: 'Contains', op: 'like'},
      does_not_contain: {name: 'Does not Contain', op: 'not like'},
      equals: {name: 'Equals', op: '='},
      gte: {name: 'Greater Than Equals', op: '>='},
      lte: {name: 'Less Than Equals', op: '<='},
      gt: {name: 'Greater Than', op: '>'},
      lt: {name: 'Less Than', op: '<'}
    }


    attr_reader :and_conditions

    attr_accessor :values
    attr_accessor :condition
    attr_accessor :errors
    attr_accessor :klass

    def initialize(klass, opts={})
      @values = []
      @errors = []
      @klass = klass
      @condition = ""
      @and_conditions = opts.blank? ? [] : parse_conditions(symbolize_keys_deep!(opts))
    end

    def self.fields(klass, rejected_columns = [])
      klass.column_names.reject{|c|rejected_columns.include?(c)}.map{|name|[name.titleize, name]}
    end

    def self.operators(rejected_operators = [])
      OPERATORS.values.reject{|c|rejected_operators.include?(c[:name])}.map{|o|[o[:name], o[:op]]}
    end

    def search_options
      search_options_hash
    end

    def search_operators
      OPERATORS
    end

    def results
      if valid?
        if is_all_blank?
          klass.all
        else
          klass.where(condition, *self.values)
        end
      else
        []
      end
    end


    def valid?
      @errors.empty?
    end

    def is_all_blank?
      and_conditions.empty?
    end

    def condition
      and_condition
    end

    def error_messages
      messages = errors.reject{|e|e.class.name == 'BlankSearchFieldException'}.map{|x|x.message}
      messages.push("Illegal blank fields") if has_blank_fields?
      messages.compact.join(",")
    end


    def has_blank_fields?
      errors.any?{|x|x.class.name == 'BlankSearchFieldException'}
    end

    def and_conditions=(val)
      @and_conditions = parse_conditions(val)
    end

    def and_condition
      and_conditions.empty? ? "1=1" : and_conditions.join(' AND ')
    end

    def parse_conditions(conditions)
      valid_conditions = validate_conditions(conditions)
      valid_conditions.map do |param|
        parse_predicates(param[:search_by].to_sym,
                         param[:search_op],
                         param[:search_value])
      end
    end

    def validate_conditions(conditions)
      predicates = conditions.respond_to?(:values) ? conditions.values  : conditions
      predicates.select do |param|
        all_not_blank = param.values.all?{|x| !x.empty? }
        all_blank = param.values.all?{|x| x.empty? }
        #if !all_not_blank and !all_blank
         # param.select{|k,v|v.empty?}.each do |key,value|
            #self.errors.push(BlankSearchFieldException.new(key.to_sym))
          #end
        #end
        all_not_blank
      end
    end

    def parse_predicates(field,operator,value)
      search_field = valid_field(field)
      search_operator = valid_operator(field,operator)
      valid_datatype = search_options[field] && search_options[field][:datatype]
      self.values << parse_value(valid_datatype,search_operator,value)
      "#{search_field} #{search_operator} ?"
    end

    def valid_field(field)
      unless search_options.has_key?(field)
        self.errors.push(SearchFieldException.new(search_field: field))
        return false
      end
      search_options[field][:field]
    end

    def valid_operator(field,operator)
      if  search_options.has_key?(field) && !search_options[field][:operators].include?(operator)
        self.errors.push(SearchFieldException.new(search_op: operator))
        return false
      end
      operator
    end


    def parse_value(valid_datatype,operator, value)
      if valid_datatype == :date || valid_datatype == :datetime
        begin
          value = Date.parse(value)
        rescue
          self.errors.push(SearchFieldException.new(search_value: value))
          return false
        end
      elsif valid_datatype == :string && operator == "="
        value = value.to_s
      elsif valid_datatype == :string && (operator == "not like" || operator == "like") 
        value = "%#{value.to_s}%"
      end
      return value
    end

    def symbolize_keys_deep!(h)
      unless h.blank?
        h.keys.each do |k|
          ks    = k.respond_to?(:to_sym) ? k.to_sym : k
          h[ks] = h.delete k # Preserve order even when k == ks
          symbolize_keys_deep! h[ks] if h[ks].kind_of? Hash
        end
        h 
      end
    end

    private

    def search_options_hash
      search_hash = Hash.new
      klass.columns.each do |c|
        search_hash[c.name.to_sym] = field_hash_value(c.name, c.type) unless rejected_columns.include?(c.name)
      end
      search_hash
    end

    def datatype_opearators
      op = {boolean: [],string: [], number: [], datetime:[]  }
      op[:boolean] = OPERATORS[:equals][:op]
      op[:string] = [OPERATORS[:contains][:op],OPERATORS[:does_not_contain][:op],
        OPERATORS[:equals][:op]]

      op[:number] = [OPERATORS[:gt][:op], OPERATORS[:lt][:op], 
        OPERATORS[:gte][:op], OPERATORS[:lte][:op],OPERATORS[:equals][:op]]

      op[:datetime] = op[:number]
      op
    end

    def field_hash_value(name, field_type)
      {name: name.titleize, field: name, operators: field_operators(field_type), datatype: field_type}

    end

    def field_operators(field_type)
      if field_type.to_sym == :integer || field_type.to_sym == :float 
        datatype_opearators[:number]
      elsif field_type.to_sym == :date || field_type.to_sym == :datetime
        datatype_opearators[:datetime]
      else
        datatype_opearators[field_type.to_sym]
      end
    end

    def rejected_columns
      ['id', 'created_at', 'updated_at']
    end
  end

end
