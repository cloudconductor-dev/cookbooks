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

addr = IPAddr.new(node[:'cc-bind'][:network])
prefix = node[:'cc-bind'][:network].split('/').last

if prefix.to_i > 24
    node.default[:bind][:reverse_zone] = addr.reverse
elsif prefix.to_i > 16
    node.default[:bind][:reverse_zone] = addr.reverse.split('.')[1..-1].join('.')
elsif prefix.to_i > 8
    node.default[:bind][:reverse_zone] = addr.reverse.split('.')[2..-1].join('.')
else
    node.default[:bind][:reverse_zone] = addr.reverse.split('.')[3..-1].join('.')
end

node.default[:bind][:allow_updates].push(node[:'cc-bind'][:network])
node.default[:bind][:allow_queries] = node.default[:bind][:allow_updates]

ruby_block 'nameservers' do
  block do
    node.default[:bind][:forwarders].clear
    File.open('/etc/resolv.conf') do |f|
      f.each_line do |line|
        line.match(/^nameserver\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/) do |m|
          node.default[:bind][:forwarders] << m[1]
        end
      end
    end
  end
end

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
  notifies :restart, 'service[bind]', :immediately
  only_if  { platform_family?('rhel') }
end
