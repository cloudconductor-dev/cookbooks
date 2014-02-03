#
# Cookbook Name:: cc-bind9
# Recipe:: default
#

package "bind" do
  case node[:platform]
  # TODO: check package name
  when "centos", "redhat", "suse", "fedora"
    package_name "bind"
  when "debian", "ubuntu"
    package_name "bind"
  end
  action :install
end

service "bind" do
  case node[:platform_family]
  # TODO: check service name
  when 'rhel'
    service_name 'named'
  end
  supports [ :status, :reload, :restart ]
  action [ :enable, :start ]
end

node.default[:bind][:reverse_zone] = IPAddr.new(node[:ipaddress]).reverse.split('.')[1..-1].join('.')
node.default[:bind][:allow_updates].push("#{node[:ipaddress].split('.')[0..2].join('.')}.0/24")
node.default[:bind][:allow_queries] = node.default[:bind][:allow_updates]

template "named.conf" do
  case node[:platform_family]
  # TODO: check path
  when 'rhel'
    path "/etc/named.conf"
  else
    path "/etc/bind/named.conf"
  end
  source "named.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

# TODO: other platforms
directory "/etc/named" do
  owner "root"
  group "named"
  mode 0775
  action :create
  only_if  { platform_family?('rhel') }
end

template "forward.zone" do
  case node[:platform_family]
  # TODO: check path
  when 'rhel'
    path "/etc/named/#{node['bind']['forward_zone']}"
  else
    path "/etc/bind/"
  end
  source "forward.zone"
  owner "named"
  group "named"
  mode 0644
end

template "reverse.zone" do
  case node[:platform_family]
  # TODO: check path
  when 'rhel'
    path "/etc/named/#{node['bind']['reverse_zone']}"
  else
    path "/etc/bind/"
  end
  source "reverse.zone"
  owner "named"
  group "named"
  mode 0644
end

# Set IPv4 only
# TODO: fedora and other OS
template '/etc/sysconfig/named' do
  source   'etc-sysconfig-named.erb'
  owner    'root'
  group    'root'
  mode     '0644'
  notifies :restart, 'service[bind]'
  only_if  { platform_family?('rhel') }
end
