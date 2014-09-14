name             'ssl_certificate'
maintainer       'Onddo Labs, Sl.'
maintainer_email 'team@onddo.com'
license          'Apache 2.0'
description      'The main purpose of this cookbook is to make it easy for other cookbooks to support SSL. With the resource included, you will be able to manage certificates reading them from attributes, data bags or chef-vaults. Exposing its configuration through node attributes.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.1'

provides 'ssl_certificate'
