include_attribute 'elasticsearch::default'
include_attribute 'limber::default'

node.set['java']['jdk_version'] = 7
node.set['java']['install_flavor'] = 'oracle'
node.set['java']['oracle']['accept_oracle_download_terms'] = true

node.set['elasticsearch']['cluster']['name'] = node['app']['name']
node.set['elasticsearch']['discovery']['zen']['ping']['multicast']['enabled'] = false
node.set['elasticsearch']['bootstrap']['mlockall'] = false