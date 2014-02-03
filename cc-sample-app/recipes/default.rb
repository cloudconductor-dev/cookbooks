template 'index.html' do
  source   'index.html.erb'
  path     "#{node['apache']['docroot_dir']}/index.html"
  owner    'root'
  group    node['apache']['root_group']
  mode     '0644'
  variables({
    :date => Time.now.to_s
  })
end

remote_directory "index_files" do
  path      "#{node['apache']['docroot_dir']}/index_files"
  owner    'root'
  group    node['apache']['root_group']
  mode     '0755'
end
