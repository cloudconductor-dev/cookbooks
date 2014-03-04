connection_info = {
  host: node['cc-deploy']['servers']['database'].first['host'],
  port: node['cc-deploy']['servers']['database'].first['port'],
  username: node['cc-deploy']['database']['root_username'],
  password: node['cc-deploy']['database']['root_password'],
}

case node['cc-deploy']['database']['type']
when 'postgresql'
  require 'rbconfig'
  pg_config_path = `which pg_config`.chomp

  gem_package "pg" do
    gem_binary "#{RbConfig::CONFIG['bindir']}/gem"
    options("-- --with-pg-config=#{pg_config_path}")
    action :install
  end
  provider_database = Chef::Provider::Database::Postgresql
  provider_database_user = Chef::Provider::Database::PostgresqlUser
when 'mysql'
  provider_database = Chef::Provider::Database::Mysql
  provider_database_user = Chef::Provider::Database::MysqlUser
when 'sql_server'
  provider_database = Chef::Provider::Database::SqlServer
  provider_database_user = Chef::Provider::Database::SqlServerUser
else
  Chef::Application.fatal!("Unsupported db type #{node['cc-deploy']['db']['type']}")
end

database_user 'create_user' do
  connection connection_info
  username node['cc-deploy']['database']['username']
  password node['cc-deploy']['database']['password']
  provider provider_database_user
  action :create
  only_if { node['cc-deploy']['database']['username'] }
end

database 'create_database' do
  connection connection_info
  database_name node['cc-deploy']['database']['dbname']
  owner node['cc-deploy']['database']['username']
  provider provider_database
  action :create
  only_if { node['cc-deploy']['database']['dbname'] }
end

database 'execute_sql' do
  connection connection_info
  database_name node['cc-deploy']['database']['dbname']
  sql { File.read(node['cc-deploy']['database']['source_path']) }
  provider provider_database
  action :query
  only_if { node['cc-deploy']['database']['source_path'] }
end
