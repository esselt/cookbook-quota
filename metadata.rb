name             'quota'
maintainer       'Boye Holden'
maintainer_email 'boye.holden@hist.no'
license          'Apache 2.0'
description      'Enables quotasupport on Debian OS family'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe 'quota::default', 'Runs recipe enable, then clean'
recipe 'quota::enable', 'Installs quota and quotatool, enables quotasupport on all EXT3/4 filesystems'
recipe 'quota::clean', 'Checks and removes quota for non existing users on all file systems'

%w(ubuntu debian).each do |os|
  supports os
end
