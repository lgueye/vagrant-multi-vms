require 'minitest/spec'

describe_recipe 'limber::appserver' do

  elasticsearch_config_file = '/etc/elasticsearch/elasticsearch.yml'

  it 'elasticsearch config file should include configured cluster' do
    file(elasticsearch_config_file).must_include 'cluster.name: limber'
  end

  it 'elasticsearch service should be running' do
    service('elasticsearch').must_be_running
  end

  it 'elasticsearch service should be scheduled at startup' do
    service('elasticsearch').must_be_enabled
  end

end
