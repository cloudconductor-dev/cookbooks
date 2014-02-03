#
# Cookbook Name:: zabbix
# Recipe:: web_pgsql
#
# Copyright 2013, TIS Inc.
#
include_recipe "apache2::default"
include_recipe "yum::remi"

service "httpd" do
  supports :status => true, :start => true, :stop => true, :restart => true
  retries 2
  retry_delay 10
  action [ :nothing ]
end

include_recipe "cc-zabbix::yum_repository"

# Zabbix Server Web Packages
case node['zabbix']['server']['db_install_method']
when "pgsql"
  include_recipe "postgresql::server"
  include_recipe "postgresql::config_initdb"
  %w{ zabbix-web-pgsql zabbix-web zabbix-web-japanese }.each do |pkg|
    package pkg do
      action :install
    end
  end
end

directory node['zabbix']['webphp_dir'] do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

# install zabbix PHP config file
template "#{node.zabbix.webphp_dir}/zabbix.conf.php" do
  source "zabbix_web.conf.php.erb"
  owner "root"
  group "root"
  mode "644"
  notifies :restart, "service[httpd]", :immediately
end

template "/etc/php.ini" do
  source "zabbix_web_php.ini.erb"
  owner "root"
  group "root"
  mode "644"
  notifies :restart, "service[httpd]", :immediately
end

cookbook_file "/etc/httpd/conf.d/zabbix.conf" do
  source "zabbix.conf"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, "service[httpd]", :immediately
end
