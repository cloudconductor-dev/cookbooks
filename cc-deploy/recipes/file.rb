if node['deploy']['file']['source_path']
  if node['deploy']['file']['source_path'].match(/\.(gz|bz2|bin|zip|jar|tgz|tbz)$/)
    ark node['deploy']['file']['name'] do
      url "file:#{node['deploy']['file']['source_path']}"
      path "#{node['deploy']['file']['install_path']}/#{node['deploy']['file']['name']}"
      owner node['deploy']['file']['owner']
      group node['deploy']['file']['group']
      action :dump
    end
  else
    file "#{node['deploy']['file']['install_path']}/#{node['deploy']['file']['name']}" do
      content IO.read(node['deploy']['file']['source_path'])
    end
  end
end
