#
# Cookbook Name:: zabbix
# Recipe:: import_templates
#
# Copyright 2013, TIS Inc.
#
import_files = node['zabbix']['import_files']
tmp_dir = Chef::Config[:file_cache_path]

%w(zbxapi trollop).each do |pkg|
  gem_package pkg do
    action :install
  end
end

cookbook_file "#{tmp_dir}/import_zabbix_template.rb" do
  source "import_zabbix_template.rb"
  mode 0755
  owner "zabbix"
  group "zabbix"
end

cookbook_file "#{tmp_dir}/update_zabbix_template_name.rb" do
  source "update_zabbix_template_name.rb"
  mode 0755
  owner "zabbix"
  group "zabbix"
end

import_files.each do |f|
  file_url, file_name = f[:file_url], f[:file_url].split('/').last

  remote_file "#{tmp_dir}/#{file_name}" do
    source file_url
    action :create
    mode 0644
    owner "zabbix"
    group "zabbix"
  end

  execute "#{tmp_dir}/import_zabbix_template.rb --zabbix-server #{node.zabbix.server.ipaddress} --template #{tmp_dir}/#{file_name}" do
    action :run
    user "zabbix"
    only_if { `ls #{tmp_dir}/#{file_name} | wc -l`.to_i == 1 }
  end

  execute "#{tmp_dir}/update_zabbix_template_name.rb --zabbix-server #{node.zabbix.server.ipaddress} --current-name \'#{f[:current_template_name]}\' --update-name \'#{f[:update_template_name]}\'" do
    action :run
    user "zabbix"
    only_if { `ls #{tmp_dir}/#{file_name} | wc -l`.to_i == 1 }
  end

  file "#{tmp_dir}/#{file_name}" do
    action :delete
  end
end

file "#{tmp_dir}/import_zabbix_template.rb" do
  action :delete
end

file "#{tmp_dir}/update_zabbix_template_name.rb" do
  action :delete
end
