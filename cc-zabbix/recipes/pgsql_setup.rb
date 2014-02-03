#
# Cookbook Name:: zabbix
# Recipe:: pgsql_setup
#
# Copyright 2013, TIS Inc.
#
include_recipe "postgresql::server"
include_recipe "postgresql::config_initdb"

dbhost = '127.0.0.1'
dbversion = node['zabbix']['server']['database']['version']
dbport = node['zabbix']['server']['database']['dbport']
dbuser = node['zabbix']['server']['database']['dbuser']
dbpass = node['zabbix']['server']['database']['dbpassword']
dbname = node['zabbix']['server']['database']['dbname']
initial_sql_dir = "#{node['zabbix']['schema_basedir']}/zabbix-server-pgsql-*"

service "postgresql-#{dbversion}" do
  supports :status => true, :start => true, :stop => true, :restart => true
  action :start
end

execute "mv /var/lib/pgsql/.pgpass /var/lib/pgsql/.pgpass.bak" do
  action :run
  user "postgres"
  only_if { File.exists?("/var/lib/pgsql/.pgpass") }
end

template "/var/lib/pgsql/.pgpass" do
  source "zabbix.pgpass.erb"
  owner "postgres"
  group "postgres"
  mode "600"
  action :create
  user "postgres"
end

execute "Create Zabbix DB User" do
  command "/usr/bin/psql -U postgres -d postgres -w -c \"create user #{dbuser} with encrypted password '#{dbpass}' nocreatedb nocreateuser\""
  action :run
  user "postgres"
  only_if { `sudo -u postgres -- /usr/bin/psql -Atw -U postgres -d postgres -c "select count(*) from pg_user where usename='#{dbuser}'"`.to_i == 0 }
end

execute "Create Zabbix Database" do
  command "/usr/bin/psql -U postgres -d postgres -w -c \"create database #{dbname} owner #{dbuser}\""
  action :run
  user "postgres"
  only_if { `sudo -u postgres -- /usr/bin/psql -Atw -U postgres -d postgres -c "select count(*) from pg_database where datname='#{dbname}'"`.to_i == 0 }
end

execute "Import schema.sql" do
  command "/usr/bin/psql -h #{dbhost} -p #{dbport} -U #{dbuser} -d #{dbname} -w -f #{initial_sql_dir}/create/schema.sql"
  action :run
  user "postgres"
  only_if { `sudo -u postgres -- /usr/bin/psql -Atw -h #{dbhost} -p #{dbport} -U #{dbuser} -d #{dbname} -c "select count(*) from pg_tables where tablename='user_history'"`.to_i == 0 }
end

execute "Import images.sql" do
  command "/usr/bin/psql -h #{dbhost} -p #{dbport} -U #{dbuser} -d #{dbname} -w -f #{initial_sql_dir}/create/images.sql"
  action :run
  user "postgres"
  only_if { `sudo -u postgres -- /usr/bin/psql -Atw -h #{dbhost} -p #{dbport} -U #{dbuser} -d #{dbname} -c "select count(*) from images"`.to_i == 0 }
end

execute "Import data.sql" do
  command "/usr/bin/psql -h #{dbhost} -p #{dbport} -U #{dbuser} -d #{dbname} -w -f #{initial_sql_dir}/create/data.sql"
  action :run
  user "postgres"
  only_if { `sudo -u postgres -- /usr/bin/psql -Atw -h #{dbhost} -p #{dbport} -U #{dbuser} -d #{dbname} -c "select count(*) from item_discovery"`.to_i == 0 }
end

cookbook_file "/var/lib/pgsql/.pgpass" do
  action :delete
  backup false
  user "postgres"
end

execute "mv -f /var/lib/pgsql/.pgpass.bak /var/lib/pgsql/.pgpass" do
  action :run
  user "postgres"
  only_if { File.exists?("/var/lib/pgsql/.pgpass.bak") }
end
