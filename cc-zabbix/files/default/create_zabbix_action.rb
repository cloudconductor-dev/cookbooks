#!/bin/env ruby

require 'rubygems'
require 'zbxapi'
require 'trollop'

opts = Trollop::options do
  opt :zabbix_server, 'option zabbix-server', :type    => :string
  opt :server_name, 'option server-name', :type    => :string
  opt :hostgroup, 'option hostgroup', :type    => :string
  opt :template, 'option template', :type    => :string
end
ZABBIX_SERVER = opts[:zabbix_server].nil? ? '127.0.0.1' : opts[:zabbix_server]
ZABBIX_API_URL = "http://#{ZABBIX_SERVER}/zabbix/api_jsonrpc.php"
ZABBIX_LOGINID = "Admin"
ZABBIX_PASSWORD = "zabbix"
SERVER_NAME = opts[:server_name]
HOSTGROUP = opts[:hostgroup]
TEMPLATE = opts[:template]

zbxapi = ZabbixAPI.new(ZABBIX_API_URL, {:custom_headers => {}})
zbxapi.login(ZABBIX_LOGINID, ZABBIX_PASSWORD)
tmpl = zbxapi.template.get({:filter => {:name => TEMPLATE.split(',')}})
group = zbxapi.hostgroup.get({:filter => {:name => HOSTGROUP.split(',')}})
zbxapi.raw_api('action.create', {
  :name => "action_#{SERVER_NAME}",
  :evaltype => 0,
  :eventsource => 2,
  :operations => [{
    :operationtype => 2,  # add host
  },{
    :operationtype => 4,  # add to host group
    :opgroup => group,
  },{
    :operationtype => 6,  # link to template
    :optemplate => tmpl,
  }],
  :conditions => [{
    :conditiontype => 24,  # hostmetadata
    :operator => 2,  # like
    :value => SERVER_NAME,
  }]
}) 
