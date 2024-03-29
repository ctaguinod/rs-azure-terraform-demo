name 'demo'
maintainer 'The Authors'
maintainer_email 'you@example.com'
license 'All Rights Reserved'
description 'Installs/Configures demo'
long_description 'Installs/Configures demo'
version '0.1.0'
chef_version '>= 14.0'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/demo/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/demo'

# https://supermarket.chef.io/cookbooks/azure_file
# depends 'azure_file', '~> 0.2.2'
depends 'azure_file'

# https://supermarket.chef.io/cookbooks/iis
# depends 'iis', '~> 7.2.0'
depends 'iis'