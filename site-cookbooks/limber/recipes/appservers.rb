include_recipe 'java'
include_recipe 'jetty'

package 'libmysql-java' do
  action :install
end

package 'libjetty-extra' do
  action :install
end

bash 'install tomcat-jdbc' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  wget http://search.maven.org/remotecontent?filepath=org/apache/tomcat/tomcat-jdbc/7.0.42/tomcat-jdbc-7.0.42.jar -O tomcat-jdbc-7.0.42.jar
  cp tomcat-jdbc-7.0.42.jar /usr/share/java
  ln -s /usr/share/java/tomcat-jdbc-7.0.42.jar /usr/share/java/tomcat-jdbc.jar
  chmod 0770 /usr/share/java/tomcat-jdbc.jar
  EOH
end

bash 'update jetty lib directory' do
  user 'root'
  code <<-EOH
  if test ! -h /usr/share/jetty/lib/tomcat-jdbc.jar
  then
    ln -s /usr/share/java/tomcat-jdbc.jar /usr/share/jetty/lib/tomcat-jdbc.jar
  fi

  if test ! -h /usr/share/jetty/lib/mysql-connector-java.jar
  then
    ln -s /usr/share/java/mysql-connector-java.jar /usr/share/jetty/lib/mysql-connector-java.jar
  fi
  EOH
end

template '/etc/jetty/jetty.xml' do
  source 'jetty.xml.erb'
  mode '0644'
  owner 'root'
  group 'root'
  notifies :restart, 'service[jetty]', :immediately
end

