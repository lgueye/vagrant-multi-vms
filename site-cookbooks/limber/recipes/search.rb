include_recipe 'java'

bash 'fix elasticsearch outdated jdk seeking algorithm' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  if test ! -h /usr/lib/jvm/java-7-oracle
  then
    ln -s /usr/lib/jvm/default-java /usr/lib/jvm/java-7-oracle
  fi
  EOH
end

include_recipe 'elasticsearch::deb'

template '/etc/elasticsearch/elasticsearch.yml' do
  source 'elasticsearch.yml.erb'
  mode '0644'
  owner 'root'
  group 'root'
end
