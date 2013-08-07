include_recipe "mysql::server"

mysql_connection = {:host => "localhost", :username => 'root',
                    :password => node['mysql']['server_root_password']}

mysql_database node['app']['db_schema'] do
  connection mysql_connection
  action :create
end

mysql_database_user node['app']['db_user'] do
  connection mysql_connection
  password node['app']['db_password']
  database_name node['app']['db_schema']
  host '%'
  privileges [:select,:update,:insert, :delete]
  action [:create, :grant]
end
