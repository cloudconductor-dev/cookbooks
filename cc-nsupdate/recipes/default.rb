#
# Cookbook Name:: cc-nsupdate
# Recipe:: default
#
# Copyright 2013, TIS Inc.
#
case node[:platform]
when "centos", "redhat"
  package 'bind-utils' do
    action :install
  end
end

ohai 'reload' do
  action :reload
end

ruby_block 'generate_fqdn' do
  block do
    node.default[:nsupdate][:fqdn] = "#{node['hostname']}.#{node[:nsupdate][:domain]}"
  end
  action :run
end

tmp_dir = Chef::Config[:file_cache_path]
template "#{tmp_dir}/nsupdate.params" do
  source "nsupdate.erb"
  owner "root"
  group "root"
  mode 0600
end

execute 'nsupdate' do
  user 'root'
  command "cat #{tmp_dir}/nsupdate.params | /usr/bin/nsupdate"
  retries node['nsupdate']['retries']
  retry_delay node['nsupdate']['retry_delay']
  action :run
end

file "#{tmp_dir}/nsupdate.params" do
  action :delete
end

template '/etc/resolv.conf' do
  source 'resolv.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

case node[:platform_family]
when 'rhel'
  execute 'disable peerdns' do
    user 'root'
    command 'grep ^PEERDNS /etc/sysconfig/network-scripts/ifcfg-eth0 && sed -i -e "s/^PEERDNS.*/PEERDNS=no/g" /etc/sysconfig/network-scripts/ifcfg-eth0 || echo "PEERDNS=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0'
    action :run
  end
end
