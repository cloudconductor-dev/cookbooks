node['cc-deploy']['applications'].each do |application|
  case application['type'] || node['cc-deploy']['application']['default']['type']
  when 'java'
    application application['name'] do
      path application['install_path'] || node['cc-deploy']['application']['default']['install_path']
      repository application['source_path']
      scm_provider Chef::Provider::File::Deploy
      java_webapp do
        context_template "context.xml.erb"
        database do
          node = Chef::Resource::ApplicationJavaJavaWebapp::node
          node.default = Chef::Resource::ApplicationJavaJavaWebapp::node.default
          database_port = node['cc-deploy']['database_servers'].first['port']
          database_default_port = node.default['cc-deploy']['database_servers_default']['port']
          username   node['cc-deploy']['database']['username']
          password   node['cc-deploy']['database']['password']
          driver     "org.#{node['cc-deploy']['database']['type']}.Driver"
          adapter    node['cc-deploy']['database']['type']
          host       node['cc-deploy']['database_servers'].first['host']
          port       database_port.nil? ? database_default_port : database_port
          database   node['cc-deploy']['database']['dbname']
          max_active application['max_active'] || node['cc-deploy']['application']['default']['max_active']
          max_idle   application['max_idle'] || node['cc-deploy']['application']['default']['max_idle']
          max_wait   application['max_wait'] || node['cc-deploy']['application']['default']['max_wait']
        end
      end
      tomcat
    end
  end
end
