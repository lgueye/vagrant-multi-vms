app_name="limber"

require 'berkshelf/vagrant'

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu-server-12.04"
  config.vm.box_url = "https://s3-us-west-2.amazonaws.com/squishy.vagrant-boxes/precise64_squishy_2013-02-09.box"

  config.vm.provider :virtualbox do |vbox|
    vbox.customize ["modifyvm", :id, "--memory", "512"]
    vbox.customize ["modifyvm", :id, "--cpus", "2"]
    vbox.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  # Proxy
  config.vm.define :proxy do |proxy|
    proxy.vm.hostname = "#{app_name}-haproxy"
    proxy.vm.network :private_network, ip: "192.168.10.5"
    #proxy.vm.network :forwarded_port, guest: 80, host: 8080

    proxy.vm.provider :virtualbox do |vbox|
      vbox.name = "#{proxy.vm.hostname}"
    end

    proxy.vm.provision "chef_solo" do |chef|
      chef.add_recipe "haproxy"
    end
  end

end
