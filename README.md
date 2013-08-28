vagrant-multi-vms
=================

Support automatic application cluster creation and provision Vagrant and Chef

First version
=============

* Use TDD with minitest
* Use Vagrant with Virtual Box
* Use Chef solo
* Create a cluster with a proxy (haproxy), 2 app servers (jetty), a db (mysql) and 1 search engine (elasticsearch)
 
Main commands
=============

* time vagrant up
* time vagrant halt -f
* time vagrant destroy

The time is not mandatory but i gives you an idea of the time take to build the cluster from the ground.
Once downloaded, you may run vagrant reload and note the duration difference.


