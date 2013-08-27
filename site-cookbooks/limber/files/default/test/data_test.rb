require 'minitest/spec'
require File.dirname(__FILE__) + '/data_helper.rb'

describe_recipe 'limber::data' do

  include Helpers::Data

  it "try selecting on database with user 'limber' on schema 'limber' should succeed" do
    assert_user_can_connect_to_schema(
        node['app']['db']['schema'],
        node['app']['db']['user'],
        node['app']['db']['password'])
  end

end
