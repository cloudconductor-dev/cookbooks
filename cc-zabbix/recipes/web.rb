#
# Cookbook Name:: zabbix
# Recipe:: web
#
# Copyright 2013, TIS Inc.
#
case node['zabbix']['web']['install_method']
when 'yum'
  include_recipe "cc-zabbix::web_#{node['zabbix']['web']['install_method']}"
else
  include_recipe "zabbix::web_#{node['zabbix']['web']['install_method']}"
end
