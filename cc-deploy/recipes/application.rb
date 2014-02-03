node['deploy']['applications'].each do |application|
  case application['type'] || node['deploy']['application']['default']['type']
  when 'java'
    application application['name'] do
      path application['install_path'] || node['deploy']['application']['default']['install_path']
      repository application['source_path']
      scm_provider Chef::Provider::File::Deploy
      java_webapp do
        context_template "context.xml.erb"
        database do
          username   node['deploy']['database']['username']
          password   node['deploy']['database']['password']
          driver     "org.#{node['deploy']['database']['type']}.Driver"
          adapter    node['deploy']['database']['type']
          host       node['deploy']['servers']['database'].first['host']
          port       node['deploy']['servers']['database'].first['host']
          database   node['deploy']['database']['dbname']
          max_active application['max_active'] || node['deploy']['application']['default']['max_active']
          max_idle   application['max_idle'] || node['deploy']['application']['default']['max_idle']
          max_wait   application['max_wait'] || node['deploy']['application']['default']['max_wait']
        end
      end
      tomcat
    end
  end
end
