require 'minitest/spec'

describe_recipe 'limber::proxy' do

  haproxy_config_file = '/etc/haproxy/haproxy.cfg'

  # = Checking file timestamps =
  it 'should touch haproxy config file' do
    file(haproxy_config_file).must_be_modified_after(run_status.start_time)
  end

  it 'should include app servers settings' do
    file(haproxy_config_file).must_include 'limber-jetty-0'
    file(haproxy_config_file).must_include 'limber-jetty-1'
  end
end