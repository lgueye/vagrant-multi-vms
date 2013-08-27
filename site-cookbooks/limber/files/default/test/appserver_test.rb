require 'minitest/spec'

describe_recipe 'limber::appserver' do

  jetty_config_file = '/etc/jetty/jetty.xml'

  it 'should touch jetty config file' do
    file(jetty_config_file).must_be_modified_after(run_status.start_time)
  end

  it 'jetty config file should include configured datasource' do
    file(jetty_config_file).must_include '<Arg>jdbc/limber</Arg>'
    file(jetty_config_file).must_include 'limber-datasource'
  end

  it 'jetty service should be running' do
    service('jetty').must_be_running
  end

  it 'jetty service should be scheduled at startup' do
    service('jetty').must_be_enabled
  end

end
