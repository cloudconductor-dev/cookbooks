#
# Cookbook Name:: cc-nsupdate
# Attributes:: nsupdate
#
# Copyright 2013, TIS, Inc.
#
require 'ipaddr'

# DNS server
default['nsupdate']['dns_server'] = '127.0.0.1'

# TTL
default['nsupdate']['ttl'] = 3600

# FQDN
default['nsupdate']['domain'] = node['domain'] || 'localdomain'
default['nsupdate']['fqdn'] = node['fqdn'] || "#{node['hostname']}.#{node[:nsupdate][:domain]}"

# IP address(should not be more than 2 IPs)
default['nsupdate']['ipaddress'] = node[:ipaddress]
default['nsupdate']['ipaddress_rev'] = IPAddr.new(node[:nsupdate][:ipaddress]).reverse

default['nsupdate']['retries'] = 10
default['nsupdate']['retry_delay'] = 60
