if node['cc-deploy']['file']['source_path']
  if node['cc-deploy']['file']['source_path'].match(/\.(gz|bz2|bin|zip|jar|tgz|tbz)$/)
    ark node['cc-deploy']['file']['name'] do
      url "file:#{node['cc-deploy']['file']['source_path']}"
      path "#{node['cc-deploy']['file']['install_path']}/#{node['cc-deploy']['file']['name']}"
      owner node['cc-deploy']['file']['owner']
      group node['cc-deploy']['file']['group']
      action :dump
    end
  else
    file "#{node['cc-deploy']['file']['install_path']}/#{node['cc-deploy']['file']['name']}" do
      content IO.read(node['cc-deploy']['file']['source_path'])
    end
  end
end
