require "purify/version"
require "purify/search"
require "purify/active_record/active_record"
require 'purify/helpers/form_builder.rb'
require 'action_controller'
ActionController::Base.helper Purify::FormHelper::FormBuilder
