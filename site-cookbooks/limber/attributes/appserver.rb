include_attribute 'java'
include_attribute 'jetty'
include_attribute 'limber::default'
include_attribute 'limber::data'

node.set['java']['jdk_version'] = '7'
node.set['java']['install_flavor'] = 'oracle'
node.set['java']['oracle']['accept_oracle_download_terms'] = true

node.set['app']['appservers'] = []
2.times.map { |i|
  node['app']['appservers'].push(
      {
          'hostname' => "#{node['app']['name']}-appserver-#{i}",
          'ipaddress' => "192.168.10.#{ i + 10}",
          'port' => node['jetty']['port'],
          'proxy_weight' => 1,
          'max_connections' => 100,
          'ssl_port' => 443
      }
  )
}

node.set['haproxy']['backend_servers'] = node['app']['appservers']
