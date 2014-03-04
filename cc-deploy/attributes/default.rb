default['cc-deploy']['tmp_dir'] = '/tmp'

# Servers
default['cc-deploy']['application_servers']['default']['host'] = nil
default['cc-deploy']['application_servers']['default']['port'] = node['tomcat']['port']
default['cc-deploy']['database_servers']['default']['host'] = nil
default['cc-deploy']['database_servers']['default']['port'] = 5432

# Web
default['cc-deploy']['web']['type'] = 'apache'

# Application
default['cc-deploy']['application']['default']['type'] = 'java'
default['cc-deploy']['application']['default']['name'] = nil
default['cc-deploy']['application']['default']['source_path'] = nil
default['cc-deploy']['application']['default']['install_path'] = "/usr/share/tomcat"
default['cc-deploy']['application']['default']['max_active'] = 5
default['cc-deploy']['application']['default']['max_idle'] = 5
default['cc-deploy']['application']['default']['max_wait'] = -1
default['cc-deploy']['applications'] = []

# Database
default['cc-deploy']['database']['type'] = 'postgresql'
default['cc-deploy']['database']['root_username'] = 'postgres'
default['cc-deploy']['database']['root_password'] = nil
default['cc-deploy']['database']['dbname'] = node['cc-deploy']['application']['name']
default['cc-deploy']['database']['username'] = node['cc-deploy']['application']['name']
default['cc-deploy']['database']['password'] = node['cc-deploy']['application']['name']
default['cc-deploy']['database']['source_path'] = nil

# File
default['cc-deploy']['file']['source_path'] = nil
default['cc-deploy']['file']['install_path'] = nil
default['cc-deploy']['file']['name'] = nil
default['cc-deploy']['file']['owner'] = nil
default['cc-deploy']['file']['group'] = nil
