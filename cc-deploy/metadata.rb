name 'cc-deploy'
description 'deploy application'
maintainer 'TIS Inc.'
maintainer_email 'cloudconductor@tis.co.jp'
license 'LGPL v3'
version '0.1.0'

%w{ ark apache2 application_java database postgresql }.each do |cookbook|
  depends cookbook
end
