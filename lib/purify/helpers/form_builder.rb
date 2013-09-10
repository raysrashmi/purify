require 'purify/search'
module Purify
  module FormHelper
    module FormBuilder
      def render_search_partial(klass, opt = {})
        content_tag(:div, class: 'container') do
          (1..3).each do|i|
            concat(
              content_tag(:div) do
                content_tag(:select,  options_for_select(Purify::Search.fields(klass)), 
                          prompt: 'Please Select...', class: 'search_by', name: "and_conditions[#{i}][search_by]")+
                content_tag(:select, options_for_select(Purify::Search.operators),
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
