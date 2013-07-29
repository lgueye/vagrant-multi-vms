app_name="limber"

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
  config.vm.define :mysql do |mysql|
    mysql.vm.hostname = "#{app_name}-mysql"
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

  # Proxy
  config.vm.define :proxy do |proxy|
    proxy.vm.hostname = "#{app_name}-haproxy"
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
