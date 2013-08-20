name             'limber'
maintainer       'Louis Gueye'
maintainer_email 'louis.gueye@gmail.com'
license          'Apache 2.0'
description      'Installs/Configures limber app'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe 'limber::default', 'Configures limber app'

depends "java"
depends "jetty"
depends "mysql55"
depends "database"
depends "haproxy"
depends "elasticsearch"


