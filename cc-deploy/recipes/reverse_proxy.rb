case node['deploy']['web']['type']
when 'apache'
  template "proxy.conf" do
    path "#{node['apache']['dir']}/conf.d/proxy.conf"
    mode '0644'
    action :create
    not_if node['deploy']['applications'].empty?
  end
end
