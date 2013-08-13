app_name = 'limber'

Vagrant.configure("2") do |config|

  config.vm.box = 'ubuntu-server-12.10'
  config.vm.box_url = 'http://goo.gl/wxdwM'
  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true
  #config.landrush.enable
  config.vm.provision :hosts

  config.vm.provision 'chef_solo' do |chef|
    chef.add_recipe 'apt'
    chef.add_recipe 'curl'
    chef.cookbooks_path = %w('cookbooks','site-cookbooks')
  end

  config.vm.provider :virtualbox do |vbox|
    vbox.customize ['modifyvm', :id, '--memory', '512']
    vbox.customize ['modifyvm', :id, '--cpus', '2']
    vbox.customize ['modifyvm', :id, '--ioapic', 'on']
    vbox.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    vbox.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
  end

  # Database
  databases = "#{app_name}-mysql"
  config.vm.define databases do |mysql|
    mysql.vm.hostname = databases
    mysql.vm.network :private_network, ip: '192.168.10.2'

    mysql.vm.provider :virtualbox do |vbox|
      vbox.name = "#{mysql.vm.hostname}"
    end

    mysql.vm.provision 'chef_solo' do |chef|
      chef.add_recipe "#{app_name}::data"
    end
  end

  #App servers
  appservers = []
  2.times.map { |i|
    appservers.push(
        {
            'hostname' => "#{app_name}-jetty-#{i}",
            'ipaddress' => "192.168.10.#{ i + 10}",
            'port' => '8080',
            'proxy_weight' => 1,
            'max_connections' => 100,
            'ssl_port' => 443
        }
    )
  }

  appservers.each_index do |index|
    current_server = appservers[index]['hostname']
    config.vm.define current_server do |jetty|
      jetty.vm.hostname = current_server
      jetty.vm.network :private_network, ip: appservers[index]['ipaddress']

      jetty.vm.provider :virtualbox do |vbox|
        vbox.name = "#{jetty.vm.hostname}"
      end

      jetty.vm.provision 'chef_solo' do |chef|
        chef.add_recipe "#{app_name}::appservers"
      end
    end
  end

  # Proxy
  proxies = "#{app_name}-haproxy"
  config.vm.define proxies do |proxy|
    proxy.vm.hostname = proxies
    proxy.vm.network :private_network, ip: '192.168.10.5'

    proxy.vm.provider :virtualbox do |vbox|
      vbox.name = "#{proxy.vm.hostname}"
    end

    proxy.vm.provision 'chef_solo' do |chef|
      chef.add_recipe "#{app_name}::proxy"
    end
  end

  # Search engine
  elasticsearch = "#{app_name}-elasticsearch"
  config.vm.define elasticsearch do |es|
    es.vm.hostname = elasticsearch
    es.vm.network :private_network, ip: '192.168.10.6'

    es.vm.provider :virtualbox do |vbox|
      vbox.name = "#{es.vm.hostname}"
    end

    es.vm.provision 'chef_solo' do |chef|
      chef.add_recipe "#{app_name}::search"
    end
  end

end
