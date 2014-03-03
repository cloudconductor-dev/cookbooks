default['deploy']['tmp_dir'] = '/tmp'

# Servers
default['deploy']['servers']['application']['default']['host'] = nil
default['deploy']['servers']['application']['default']['port'] = node['tomcat']['port']
default['deploy']['servers']['database']['default']['host'] = nil
default['deploy']['servers']['database']['default']['port'] = 5432

# Web
default['deploy']['web']['type'] = 'apache'

# Application
default['deploy']['application']['default']['type'] = 'java'
default['deploy']['application']['default']['name'] = nil
default['deploy']['application']['default']['source_path'] = nil
default['deploy']['application']['default']['install_path'] = "/usr/share/tomcat"
default['deploy']['application']['default']['max_active'] = 5
default['deploy']['application']['default']['max_idle'] = 5
default['deploy']['application']['default']['max_wait'] = -1
default['deploy']['applications'] = []

# Database
default['deploy']['database']['type'] = 'postgresql'
default['deploy']['database']['root_username'] = 'postgres'
default['deploy']['database']['root_password'] = nil
default['deploy']['database']['dbname'] = node['deploy']['application']['name']
default['deploy']['database']['username'] = node['deploy']['application']['name']
default['deploy']['database']['password'] = node['deploy']['application']['name']
default['deploy']['database']['source_path'] = nil

# File
default['deploy']['file']['source_path'] = nil
default['deploy']['file']['install_path'] = nil
default['deploy']['file']['name'] = nil
default['deploy']['file']['owner'] = nil
default['deploy']['file']['group'] = nil
