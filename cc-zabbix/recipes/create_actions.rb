#
# Cookbook Name:: zabbix
# Recipe:: create_zabbix_host
#
# Copyright 2013, TIS Inc.
#
tmp_dir = Chef::Config[:file_cache_path]

%w(zbxapi trollop).each do |pkg|
  gem_package pkg do
    action :install
  end
end

cookbook_file "#{tmp_dir}/create_zabbix_action.rb" do
  source 'create_zabbix_action.rb'
  mode 0755
  owner 'zabbix'
  group 'zabbix'
end

server = node[:zabbix][:server][:ipaddress]
hostgroup = node[:zabbix][:host_group]
node[:zabbix][:hosts].each do |host|
  server_name, tmpls = host[:name], host[:templates]
  execute "#{tmp_dir}/create_zabbix_action.rb --zabbix-server \'#{server}\' --template \'#{tmpls.join(',')}\' --hostgroup \'#{hostgroup}\' --server-name \'#{server_name}\'" do
    action :run
    user 'root'
  end
end
