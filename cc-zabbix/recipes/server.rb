#
# Cookbook Name:: zabbix
# Recipe:: server
#
# Copyright 2013, TIS Inc.
#
case node['zabbix']['server']['install_method']
when 'yum'
  include_recipe "cc-zabbix::server_#{node['zabbix']['server']['install_method']}"
else
  include_recipe "zabbix::server_#{node['zabbix']['server']['install_method']}"
end
