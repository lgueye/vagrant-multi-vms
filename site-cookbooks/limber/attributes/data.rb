include_attribute "limber::default"
include_attribute "mysql::server"

node.set['mysql']['server_root_password'] = '*mysql-root@0'
node.set['mysql']['server_debian_password'] = '*mysql-root@0'
node.set['mysql']['server_repl_password'] = '*mysql-root@0'

node.set['app']['db']['schema'] = node['app']['name']
node.set['app']['db']['user'] = node['app']['name']
node.set['app']['db']['password'] = '*mysql-limber@0'
node.set['app']['datasource']['name'] = 'jdbc/limber'

