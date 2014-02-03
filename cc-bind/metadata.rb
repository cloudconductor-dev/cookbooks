name 'cc-bind'
description 'Install/configure bind9'
maintainer 'TIS Inc.'
maintainer_email 'cloudconductor@tis.co.jp'
license 'LGPL v3'
version '0.1.0'

%w{ bind9 }.each do |cookbook|
  depends cookbook
end
