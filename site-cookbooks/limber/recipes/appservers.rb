
package "libmysql-java" do
  action :install
end

package "libjetty-extra" do
  action :install
end

bash "install tomcat-jdbc" do
  user "root"
  cwd "/tmp"
  code <<-EOH
  wget http://search.maven.org/remotecontent?filepath=org/apache/tomcat/tomcat-jdbc/7.0.42/tomcat-jdbc-7.0.42.jar
  cp tomcat-jdbc-7.0.42.jar /usr/share/java
  ln -s /usr/share/java/tomcat-jdbc-7.0.42.jar /usr/share/java/tomcat-jdbc.jar
  chmod 775 /usr/share/java/tomcat-jdbc.jar
  EOH
end

bash "update jetty lib directory" do
  user "root"
  code <<-EOH
  ln -s /usr/share/java/tomcat-jdbc.jar /usr/share/jetty/lib/tomcat-jdbc.jar
  ln -s /usr/share/java/mysql-connector-java.jar /usr/share/jetty/lib/mysql-connector-java.jar
  EOH
end

template "/etc/jetty/jetty.xml" do
  source "jetty.xml.erb"
  mode 0440
  owner "root"
  group "root"
  variables({
    :jetty_external_libs => ["/usr/share/java/mysql-connector-java.jar", "/usr/share/java/tomcat-jdbc.jar"]
  })
  notifies :restart, "service[jetty]", :immediately
end

