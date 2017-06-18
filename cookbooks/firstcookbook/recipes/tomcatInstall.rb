###updating libraries###
execute "apt-get-update" do
  command "apt-get update"
  ignore_failure true
end

 ###installing tomcat7###
package 'tomcat7' do
        action :install
end
 
###Clearing tomcat7 webapps ROOT folder###
bash 'Clearing tomcat7 webapps ROOT folder' do
  user 'root'
  cwd '/home/ubuntu'
  code <<-EOH
  sudo rm -rf /var/lib/tomcat7/webapps/ROOT
  EOH
end
 
###copying and replacing existing ROOT.war with new ROOT.war in our cookbook files/default directory###
cookbook_file "/var/lib/tomcat7/webapps/onewar.war" do
  source "onewar.war"
  mode "0644"
 # notifies :restart, "service[tomcat7]"
end

cookbook_file "/var/lib/tomcat7/conf/server.xml" do
  source "server.xml"
  mode "0644"
 # notifies :restart, "service[tomcat7]"
end

#cookbook_file "/var/lib/tomcat7/conf/web.xml" do
#  source "web.xml"
#  mode "0644"
 # notifies :restart, "service[tomcat7]"
#end

cookbook_file "/var/lib/tomcat7/conf/domain.crt" do
  source "domain.crt"
  mode "0644"
  #notifies :restart, "service[tomcat7]"
end

cookbook_file "/var/lib/tomcat7/conf/domain.key" do
  source "domain.key"
  mode "0644"
  notifies :restart, "service[tomcat7]"
end

###restarting tomcat7 service###
service 'tomcat7' do
  supports :restart => true
end

#firewall_rule 'allow world to tomcat' do
#  port 8443
#  source '0.0.0.0/0'
#  only_if { windows? && node['firewall']['allow_tomcat'] }
#end

