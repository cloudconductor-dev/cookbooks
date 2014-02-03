#!/bin/env ruby

require 'rubygems'
require 'zbxapi'
require 'trollop'

opts = Trollop::options do
  opt :zabbix_server, 'option zabbix-server', :type    => :string
  opt :current_name, 'option current-name', :type    => :string
  opt :update_name, 'option update-name', :type    => :string
end
ZABBIX_SERVER = opts[:zabbix_server].nil? ? '127.0.0.1' : opts[:zabbix_server]
ZABBIX_API_URL = "http://#{ZABBIX_SERVER}/zabbix/api_jsonrpc.php"
ZABBIX_LOGINID = "Admin"
ZABBIX_PASSWORD = "zabbix"
CURRENT_NAME = opts[:current_name]
UPDATE_NAME = opts[:update_name]

begin
  zbxapi = ZabbixAPI.new(ZABBIX_API_URL)
  zbxapi.login(ZABBIX_LOGINID, ZABBIX_PASSWORD)
  tmpl = zbxapi.template.get({:filter => {:name => CURRENT_NAME}}).first
  tmpl.merge!(:name => UPDATE_NAME)
  zbxapi.template.update(tmpl)
rescue
  puts "ERROR: Template: [#{CURRENT_NAME}] can't change to [#{UPDATE_NAME}]."
end
