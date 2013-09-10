require 'spec_helper'

describe User do
  it "should search all users if search params are blank" do
    @search = User.search({})
    @search.results.length.should == 5
  end

  it "should search users by first_name" do
    search_params =  {:and_conditions => {'0' => {'search_by' => 'first_name', 'search_op' => 'like', 'search_value' => 'fern'}}}
    @search = User.search(search_params[:and_conditions])
    @search.results.length.should == 1
  end

  it "should search users by last_name" do
    search_params =  {:and_conditions => {'0' => {:search_by => 'last_name', :search_op => 'like', :search_value => 'smith'}}}
    @search = User.search(search_params[:and_conditions])
    @search.results.length.should == 1
  end

  it "should return errors" do
    search_params =  {:and_conditions => {'0' => {:search_by => 'firstname', :search_op => 'like', :search_value => 'rashmi'}}}
    @search = User.search(search_params[:and_conditions])
    @search.errors.blank?.should be_false
  end
  it "should return results if some seach params are valid only" do
    search_params =  {:and_conditions => {'0' => {:search_by => 'first_name', :search_op => 'like', :search_value => 'rashmi'}, '1' => {:search_by => 'last_name', :search_op => 'like', :search_value => ''}}}
    @search = User.search(search_params[:and_conditions])
    @search.errors.blank?.should be_true
  end


end

