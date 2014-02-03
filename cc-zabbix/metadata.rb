name 'cc-zabbix'
description 'Install/configure zabbix'
maintainer 'TIS Inc.'
maintainer_email 'cloudconductor@tis.co.jp'
license 'LGPL v3'
version '0.1.0'

%w{ zabbix }.each do |cookbook|
  depends cookbook
end
