module Helpers
  module Data
    include MiniTest::Chef::Assertions
    include MiniTest::Chef::Resources

    def assert_user_can_connect_to_schema(schema, user, password)
      resource = Chef::Resource::MysqlDatabase.new(schema)
      resource.connection({:host => 'localhost',
                           :username => user,
                           :password => password})
      provider = Chef::Provider::Database::Mysql.new(resource, nil).tap(&:load_current_resource)
      row = provider.send(:db).query('select 1 from dual where 1 = 1')
      assert row
    ensure
      provider.send(:close)
    end

  end
end