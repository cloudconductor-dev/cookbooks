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
          username   node['cc-deploy']['database']['username']
          password   node['cc-deploy']['database']['password']
          driver     "org.#{node['cc-deploy']['database']['type']}.Driver"
          adapter    node['cc-deploy']['database']['type']
          host       node['cc-deploy']['servers']['database'].first['host']
          port       node['cc-deploy']['servers']['database'].first['host']
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
