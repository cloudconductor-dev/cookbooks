name 'cc-sample-app'
description 'sample application for apache2'
maintainer 'TIS Inc.'
maintainer_email 'cloudconductor@tis.co.jp'
license 'LGPL v3'
version '0.1.0'

%w{ apache2 }.each do |cookbook|
  depends cookbook
end
