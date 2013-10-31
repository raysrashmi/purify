require 'purify/search'
module Purify
  module FormHelper
    module FormBuilder
      def render_search_partial(klass, opt = {})
        opt.reverse_merge!({rejected_columns: [], rejected_operators: [] })
        content_tag(:div, class: 'container') do
          #TODO: this number should be provide for configuration
          (1..3).each do|i|
            concat(
              content_tag(:div) do
                content_tag(:select,  options_for_select(Search.fields(klass, opt[:rejected_columns])), 
                          prompt: 'Please Select...', class: 'search_by', name: "and_conditions[#{i}][search_by]")+
                content_tag(:select, options_for_select(Search.operators(opt[:rejected_operators])),
                          prompt: 'Please Select..', class: 'search_op', name: "and_conditions[#{i}][search_op]")+
                content_tag(:input,'', type: 'text', name: "and_conditions[#{i}][search_value]")

              end
            )
          end
        end
      end
    end
  end
end
