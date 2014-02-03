#
# Cookbook Name:: zabbix
# Recipe:: server_rpm
#
# Copyright 2013, TIS Inc.
#

include_recipe 'cc-zabbix::yum_repository'

case node['zabbix']['server']['db_install_method']
when "pgsql"
  include_recipe "postgresql::server"
  %w{ zabbix-server-pgsql zabbix-sender zabbix-get }.each do |pkg|
    package pkg do
      action :install
      options '--enablerepo=zabbix'
    end
  end
  include_recipe "cc-zabbix::pgsql_setup"
end

# install zabbix server conf
template "#{node['zabbix']['etc_dir']}/zabbix_server.conf" do
  source "zabbix_server.conf.erb"
  owner "root"
  group "root"
  mode "644"
end

# Define zabbix-server service
service "zabbix-server" do
  supports :status => true, :start => true, :stop => true, :restart => true
  action [ :enable, :start ]
end
