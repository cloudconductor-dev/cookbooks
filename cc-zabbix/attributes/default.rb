#
# Cookbook Name:: zabbix
# Attributes:: default
include_attribute 'zabbix'
default[:zabbix][:repository_url] = 'http://repo.zabbix.com/zabbix'
default[:zabbix][:repository_rpm] = 'zabbix-release-2.2-1.el6.noarch.rpm'
default[:zabbix][:version] = '2.2'

default[:zabbix][:agent][:install] = true
default[:zabbix][:agent][:install_method] = "yum"
default[:zabbix][:agent][:allowroot] = "1"
default[:zabbix][:agent][:ipaddress] = ""
default[:zabbix][:agent][:server] = "127.0.0.1"
default[:zabbix][:agent][:hostname] = node['hostname']
default[:zabbix][:agent][:server_active] = "127.0.0.1"
default[:zabbix][:agent][:include_dir] = "/etc/zabbix/zabbix_agentd.d/"
default[:zabbix][:agent][:listen_port] = "10050"
default[:zabbix][:agent][:listen_ip] = node['ipaddress']
default[:zabbix][:agent][:hostgroups] = ['zabbix_server']
default[:zabbix][:agent][:templates] = []
default[:zabbix][:agent][:host_metadata] = ''
#
default[:zabbix][:server][:install] = true
default[:zabbix][:server][:install_method] = "yum"
default[:zabbix][:server][:db_install_method] = "pgsql"
default[:zabbix][:server][:listen_port] = "10051"
default[:zabbix][:server][:ipaddress] = ""
default[:zabbix][:server][:database][:version] = "9.3"
default[:zabbix][:server][:database][:dbname] = "zabbix"
default[:zabbix][:server][:database][:dbuser] = "zabbix"
default[:zabbix][:server][:database][:dbhost] = "localhost"
default[:zabbix][:server][:database][:dbpassword] = "zabbix"
default[:zabbix][:server][:database][:dbport] = "5432"
default[:zabbix][:server][:rds_dbhost] = nil
default[:zabbix][:server][:rds_dbport] = "3306"
default[:zabbix][:server][:rds_master_user] = nil
default[:zabbix][:server][:rds_master_password] = nil
default[:zabbix][:server][:rds_dbname] = "zabbix"
default[:zabbix][:server][:rds_dbuser] = "zabbix"
default[:zabbix][:server][:rds_dbpassword] = nil
#
default[:zabbix][:server][:web][:memory_limit] = "256M"
default[:zabbix][:server][:web][:post_max_size] = "32M"
default[:zabbix][:server][:web][:upload_max_filesize] = "16M"
default[:zabbix][:server][:web][:max_execution_time] = "600"
default[:zabbix][:server][:web][:max_input_time] = "600"
#
default[:zabbix][:web][:install] = true
default[:zabbix][:web][:install_method] = "yum"
default[:zabbix][:web][:db_install_method] = "pgsql"
#
default[:zabbix][:etc_dir] = "/etc/zabbix"
default[:zabbix][:web_dir] = "/etc/httpd/conf.d"
default[:zabbix][:webphp_dir] = "/etc/zabbix/web"
default[:zabbix][:schema_basedir] = "/usr/share/doc"
default[:zabbix][:log_dir] = "/var/log/zabbix"
default[:zabbix][:run_dir] = "/var/run/zabbix"
default[:zabbix][:hosts] = Array.new
default[:zabbix][:import_files] = Array.new
#
default[:zabbix][:login] = "zabbix"
default[:zabbix][:group] = "zabbix"
#
