app_name="limber"

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu-server-12.10"
  config.vm.box_url = "http://goo.gl/wxdwM"
  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true
  config.vm.provision :hosts

  config.vm.provision "chef_solo" do |chef|
    chef.add_recipe "apt"
    chef.add_recipe "curl"
  end

  config.vm.provider :virtualbox do |vbox|
    vbox.customize ["modifyvm", :id, "--memory", "512"]
    vbox.customize ["modifyvm", :id, "--cpus", "2"]
    vbox.customize ["modifyvm", :id, "--ioapic", "on"]
    vbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vbox.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  # Database
  databases = "#{app_name}-mysql"
  config.vm.define databases do |mysql|
    mysql.vm.hostname = databases
    mysql.vm.network :private_network, ip: "192.168.10.1"

    mysql.vm.provider :virtualbox do |vbox|
      vbox.name = "#{mysql.vm.hostname}"
    end

    mysql.vm.provision "chef_solo" do |chef|
      chef.json = {
          "mysql" => {
              "server_root_password" => "*mysql-limber@0",
              "server_debian_password" => "*mysql-limber@0",
              "server_repl_password" => "*mysql-limber@0"
          }
      }
      chef.add_recipe "mysql::server"
    end
  end

  # App servers
  app_servers = []
  2.times.map { |i|
    app_servers.push(
        {
            "hostname" => "#{app_name}-jetty-#{i}",
            "ipaddress" => "192.168.10.#{ i + 10}",
            "port" => "8080",
            "proxy_weight" => 1,
            "max_connections" => 100,
            "ssl_port" => 443
        }
    )
  }

  app_servers.each_index do |index|
    current_server = app_servers[index]['hostname']
    config.vm.define current_server do |jetty|
      jetty.vm.hostname = current_server
      jetty.vm.network :private_network, ip: app_servers[index]['ipaddress']

      jetty.vm.provider :virtualbox do |vbox|
        vbox.name = "#{jetty.vm.hostname}"
      end

      jetty.vm.provision "chef_solo" do |chef|
        chef.json = {
            "java" => {
                "jdk_version" => 7,
                "install_flavor" => "oracle",
                "oracle" => {
                    "accept_oracle_download_terms" => true
                }
            }
        }
        chef.add_recipe "java"
        chef.add_recipe "jetty"
      end
    end
  end

  # Proxy
  proxies = "#{app_name}-haproxy"
  config.vm.define proxies do |proxy|
    proxy.vm.hostname = proxies
    proxy.vm.network :private_network, ip: "192.168.10.5"

    proxy.vm.provider :virtualbox do |vbox|
      vbox.name = "#{proxy.vm.hostname}"
    end

    proxy.vm.provision "chef_solo" do |chef|
      chef.json = {
          "haproxy" => {
              "backend_servers" => app_servers
          }
      }
      chef.add_recipe "haproxy::app_lb"
    end
  end

end
