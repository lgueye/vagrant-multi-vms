app_name="limber"
app_servers = 2.times.map { |i| "#{app_name}-jetty-#{i}" }
databases = "#{app_name}-mysql"
proxies = "#{app_name}-haproxy"

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu-server-12.10"
  config.vm.box_url = "http://goo.gl/wxdwM"
  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true

  config.vm.provider :virtualbox do |vbox|
    vbox.customize ["modifyvm", :id, "--memory", "512"]
    vbox.customize ["modifyvm", :id, "--cpus", "2"]
    vbox.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  # Database
  config.vm.define databases do |mysql|
    mysql.vm.hostname = databases
    mysql.vm.network :private_network, ip: "192.168.10.1"

    mysql.vm.provider :virtualbox do |vbox|
      vbox.name = "#{mysql.vm.hostname}"
    end

    mysql.vm.provision "chef_solo" do |chef|
      chef.add_recipe "apt"
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

  # Jettys
  app_servers.each_index do |index|
    ip = "192.168.10.#{index + 10}"
    current_server = app_servers[index]

    config.vm.define current_server do |jetty|
      jetty.vm.hostname = current_server
      jetty.vm.network :private_network, ip: ip

      jetty.vm.provider :virtualbox do |vbox|
        vbox.name = "#{jetty.vm.hostname}"
      end

      jetty.vm.provision "chef_solo" do |chef|
        chef.add_recipe "apt"
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
  config.vm.define proxies do |proxy|
    proxy.vm.hostname = proxies
    proxy.vm.network :private_network, ip: "192.168.10.5"

    proxy.vm.provider :virtualbox do |vbox|
      vbox.name = "#{proxy.vm.hostname}"
    end

    proxy.vm.provision "chef_solo" do |chef|
      chef.add_recipe "apt"
      chef.add_recipe "haproxy"
    end
  end

end
