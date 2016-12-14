
include_recipe 'java'

user 'tomcat' do
  action :create
  manage_home true
end

group 'tomcat' do
  members 'tomcat'
  action :create
end

tomcat_install 'amazon-rvs' do
  version '8.0.36'
  tomcat_user 'tomcat'
  tomcat_group 'tomcat'
end

template '/opt/tomcat_amazon-rvs/conf/server.xml' do
  source 'server.xml.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'tomcat_service[amazon-rvs]', :delayed
end

remote_file '/opt/tomcat_amazon-rvs/webapps/amazon-rvs.war' do
  source node['amazon_rvs']['tomcat']['file_url']
  owner 'tomcat'
  group 'tomcat'
  action :create
  notifies :restart, 'tomcat_service[amazon-rvs]', :delayed
  mode 0644
end

tomcat_service 'amazon-rvs' do
  action [:enable, :start]
  #env_vars [{ 'JAVA_HOME' => '/usr' }]
  sensitive true
  tomcat_user 'tomcat'
  tomcat_group 'tomcat'
end
