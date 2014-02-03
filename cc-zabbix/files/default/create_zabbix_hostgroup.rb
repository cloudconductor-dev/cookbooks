#!/usr/bin/ruby

require 'rubygems'
require 'zbxapi'
require 'trollop'

opts = Trollop::options do
  opt :zabbix_server, 'option zabbix-server', :type    => :string
  opt :hostgroup, 'option hostgroup', :type    => :string
end
ZABBIX_SERVER = opts[:zabbix_server].nil? ? '127.0.0.1' : opts[:zabbix_server]
ZABBIX_API_URL = "http://#{ZABBIX_SERVER}/zabbix/api_jsonrpc.php"
ZABBIX_LOGINID = "Admin"
ZABBIX_PASSWORD = "zabbix"
HOSTGROUP = opts[:hostgroup]

zbxapi = ZabbixAPI.new(ZABBIX_API_URL)
zbxapi.login(ZABBIX_LOGINID, ZABBIX_PASSWORD)
group = zbxapi.hostgroup.get({:filter => {:name => HOSTGROUP}})
zbxapi.hostgroup.create({:name => HOSTGROUP}) if group.empty?
