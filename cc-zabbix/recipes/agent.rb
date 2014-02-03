#
# Cookbook Name:: zabbix
# Recipe:: server
#
# Copyright 2013, TIS Inc.
#
case node['zabbix']['agent']['install_method']
when 'yum'
  include_recipe "cc-zabbix::agent_#{node['zabbix']['agent']['install_method']}"
else
  include_recipe "zabbix::agent_#{node['zabbix']['agent']['install_method']}"
end
