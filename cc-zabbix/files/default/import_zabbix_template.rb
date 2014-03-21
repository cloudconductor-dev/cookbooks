#!/bin/env ruby

require 'rubygems'
require 'zbxapi'
require 'trollop'

opts = Trollop::options do
  opt :zabbix_server, 'option zabbix-server', :type    => :string
  opt :template, 'option template', :type    => :string
end
ZABBIX_SERVER = opts[:zabbix_server].nil? ? '127.0.0.1' : opts[:zabbix_server]
ZABBIX_API_URL = "http://#{ZABBIX_SERVER}/zabbix/api_jsonrpc.php"
ZABBIX_LOGINID = "Admin"
ZABBIX_PASSWORD = "zabbix"
TEMPLATE = opts[:template]

template_file = File.open(TEMPLATE, "r:utf-8").read
rules = %w(applications discoveryRules graphs groups hosts images items maps screens
           templateLinkage templates templateScreens triggers).reduce({}) do |res, rule|
  res.merge!({"#{rule}" => {:createMissing => true, :updateExisting => true}})
end

zbxapi = ZabbixAPI.new(ZABBIX_API_URL, {:custom_headers => {}})
zbxapi.login(ZABBIX_LOGINID, ZABBIX_PASSWORD)
zbxapi.configuration.import({
  :format => 'xml',
  :source => template_file,
  :rules => rules
})
