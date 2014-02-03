#
# Cookbook Name:: zabbix
# Recipe:: agent_rpm
#
# Copyright 2013, TIS Inc.
#
include_recipe 'cc-zabbix::yum_repository'

# Install from rpm package
package "zabbix-agent" do
  action :install
  options '--enablerepo=zabbix'
  notifies :start, "service[zabbix-agent]"
end

# Install configuration
template "#{node.zabbix.etc_dir}/zabbix_agentd.conf" do
  source "zabbix_agentd.conf.erb"
  owner "root"
  group "root"
  mode "644"
  notifies :restart, "service[zabbix-agent]"
end

# Define zabbix-agent service
service "zabbix-agent" do
  supports :status => true, :start => true, :stop => true, :restart => true
  action [ :enable, :start ]
end

