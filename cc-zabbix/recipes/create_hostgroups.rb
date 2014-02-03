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

cookbook_file "#{tmp_dir}/create_zabbix_hostgroup.rb" do
  source "create_zabbix_hostgroup.rb"
  mode 0755
  owner "zabbix"
  group "zabbix"
end

hostgrp = node[:zabbix][:host_group]
srv = node[:zabbix][:server][:ipaddress]
execute "#{tmp_dir}/create_zabbix_hostgroup.rb --zabbix-server #{srv} --hostgroup \"#{hostgrp}\"" do
  action :run
  user "root"
end
