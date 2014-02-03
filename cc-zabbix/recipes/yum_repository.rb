#
# Cookbook Name:: zabbix
# Recipe:: zabbix_repo
#
# Copyright 2013, TIS Inc.
#
platform = node['platform']
platform_family = node['platform_family']
platform_version = node['platform_version'].to_i
machine = node['kernel']['machine']

base_url = node['zabbix']['repository_url']
rpm_filename = node['zabbix']['repository_rpm']
zabbix_version = node['zabbix']['version']

rpm_file = "#{Chef::Config[:file_cache_path]}/#{rpm_filename}"

log "#{base_url}/#{zabbix_version}/#{platform_family}/#{platform_version}/#{machine}/#{rpm_filename}"

remote_file rpm_file do
  source "#{base_url}/#{zabbix_version}/#{platform_family}/#{platform_version}/#{machine}/#{rpm_filename}"
end

package "zabbix-release" do
  action :install
  source rpm_file
  provider Chef::Provider::Package::Rpm
end
