#
# Cookbook Name:: cc-bind9
# Attributes:: cc-bind9
#
# Copyright 2014, TIS, Inc.
#
case node[:platform_family]
when 'rhel'
  default['bind']['directory'] = '/etc/named'
else
  default['bind']['directory'] = '/etc/bind/named.conf'
end
default['bind']['allow_queries'] = ['127.0.0.1']
default['bind']['enable_forwarding'] = true
default['bind']['forwarders'] = ['127.0.0.1']
default['bind']['forward_zone'] = node['domain'] || 'localdomain'
default['bind']['allow_updates'] = ['127.0.0.1']
default['bind']['reverse_zone'] = '0.0.127.in-addr.arpa'
default['bind']['ttl'] = 3600
default['bind']['dnsip'] = '127.0.0.1'
