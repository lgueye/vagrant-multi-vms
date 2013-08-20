app_name = 'limber'

Vagrant.configure("2") do |config|

  config.vm.box = 'ubuntu-server-12.10'
  config.vm.box_url = 'http://goo.gl/wxdwM'
  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true
  #config.landrush.enable
  config.vm.provision :hosts

  config.vm.provision 'chef_solo' do |chef|
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
  data_role = 'data'
  app_data_host = "#{app_name}-#{data_role}"
  config.vm.define app_data_host do |mysql|
    mysql.vm.hostname = app_data_host
    mysql.vm.network :private_network, ip: '192.168.10.2'

    mysql.vm.provider :virtualbox do |vbox|
      vbox.customize ['modifyvm', :id, '--memory', '1024']
      vbox.name = "#{mysql.vm.hostname}"
    end

    mysql.vm.provision 'chef_solo' do |chef|
      chef.add_recipe "#{app_name}::#{data_role}"
    end
  end

  #App servers
  appserver_role = 'appserver'
  app_appserver_host = "#{app_name}-#{appserver_role}"
  appservers = []
  2.times.map { |i|
    appservers.push(
        {
            'hostname' => "#{app_appserver_host}-#{i}",
            'ipaddress' => "192.168.10.#{ i + 10}"
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
        chef.add_recipe "#{app_name}::#{appserver_role}"
      end
    end
  end

  # Proxy
  proxy_role = 'proxy'
  app_proxy_host = "#{app_name}-#{proxy_role}"
  config.vm.define app_proxy_host do |proxy|
    proxy.vm.hostname = app_proxy_host
    proxy.vm.network :private_network, ip: '192.168.10.5'

    proxy.vm.provider :virtualbox do |vbox|
      vbox.name = "#{proxy.vm.hostname}"
    end

    proxy.vm.provision 'chef_solo' do |chef|
      chef.add_recipe "#{app_name}::#{proxy_role}"
    end
  end

  # Search engine
  search_role = 'search'
  app_search_host = "#{app_name}-#{search_role}"
  config.vm.define app_search_host do |es|
    es.vm.hostname = app_search_host
    es.vm.network :private_network, ip: '192.168.10.6'

    es.vm.provider :virtualbox do |vbox|
      vbox.name = "#{es.vm.hostname}"
    end

    es.vm.provision 'chef_solo' do |chef|
      chef.add_recipe "#{app_name}::#{search_role}"
    end
  end

end
