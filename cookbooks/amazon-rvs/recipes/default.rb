
raise "node['amazon_rvs']['creds']['data_bag'] must be set" unless node['amazon_rvs']['creds']['data_bag']
raise "nnode['amazon_rvs']['tomcat']['file_url']" unless node['amazon_rvs']['tomcat']['file_url']

password = data_bag_item(node['amazon_rvs']['creds']['data_bag'], 'password')
node.run_state[:amazon_rvs_tomcat_password] = password['amazon_rvs_tomcat_user']

yum_package 'tomcat'
yum_package 'tomcat-webapps'

cookbook_file '/usr/share/tomcat/conf/tomcat.conf' do
  source 'tomcat.conf'
  action :create
  notifies :restart, 'service[tomcat]', :delayed
  mode 0644
end

template '/usr/share/tomcat/conf/server.xml' do
  source 'server.xml.erb'
  mode 0644
  notifies :restart, 'service[tomcat]', :delayed
end

template '/usr/share/tomcat/conf/tomcat-users.xml' do
  source 'tomcat-users.xml.erb'
  variables(
    user: node['amazon_rvs']['tomcat']['user'],
    password: node.run_state[:amazon_rvs_tomcat_password]
  )
  sensitive true
  mode 0644
  notifies :restart, 'service[tomcat]', :delayed
end

remote_file '/usr/share/tomcat/webapps/amazon-rvs-sandbox.war' do
  source node['amazon_rvs']['tomcat']['file_url']
  action :create
  mode 0755
end

service 'tomcat' do
  action [:enable, :start]
end
