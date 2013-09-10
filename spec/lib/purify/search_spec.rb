#require 'spec_helper'

#module Purify
  #describe Search do
    #it "should vadlidates search object valid with blank params" do
      #@dsq = Search.new(User)
      #@dsq.and_conditions.should be_empty
      #@dsq.valid?.should be_true
    #end

    #it "should validated params hash" do
      #search_params =  {:and_conditions => {'0' => {:search_by => 'first_name', :search_op => 'like', :search_value => 'rays'}}}
      #@dsq = Search.new(User, search_params[:and_conditions])
      #@dsq.valid?.should be_true
      #@dsq.and_conditions.should_not be_empty
      #@dsq.and_conditions.length.should == 1
    #end

    #it "should not validate searhc object with any blank value" do
      #search_params =  {:and_conditions => {'0' => {:search_by => 'first_name', :search_op => :like, :search_value => ''}}}
      #@dsq = Search.new(User,search_params[:and_conditions])
      #@dsq.and_conditions.should be_blank

    #end

    #it "should not validate search by field with wrong name" do
      #search_params =  {:and_conditions => {'0' => {:search_by => 'firstname', :search_op => "like", :search_value => 'rays'}}}
      #@dsq = Search.new(User, search_params[:and_conditions])

      #@dsq.and_conditions.should_not be_blank
      #@dsq.valid?.should be_false

    #end

    #it "should not validate search operator is not compatible with field" do
      #search_params =  {:and_conditions => {'0' => {:search_by => 'first_name', :search_op => "contains", :search_value => 'rays'}}}
      #@dsq = Search.new(User, search_params[:and_conditions])
      #@dsq.and_conditions.should_not be_blank
      #@dsq.valid?.should be_false
      #@dsq.error_messages.include?("Unknown search operator contains").should be_true
    #end
  #end

#end

