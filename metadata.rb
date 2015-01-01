# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate
# Author:: Raul Rodriguez (<raul@onddo.com>)
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2014 Onddo Labs, SL. (www.onddo.com)
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name 'ssl_certificate'
maintainer 'Onddo Labs, Sl.'
maintainer_email 'team@onddo.com'
license 'Apache 2.0'
description <<-EOS
The main purpose of this cookbook is to make it easy for other cookbooks to
support SSL. With the resource included, you will be able to manage certificates
reading them from attributes, data bags or chef-vaults. Exposing its
configuration through node attributes.
EOS
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.1.0' # WiP

supports 'amazon'
supports 'debian'
supports 'centos'
supports 'fedora'
supports 'freebsd'
supports 'redhat'
supports 'ubuntu'

provides 'ssl_certificate'

attribute 'ssl_certificate/key_dir',
          display_name: 'ssl_certificate key dir',
          description: 'Default SSL key directory.',
          type: 'string',
          required: 'optional',
          calculated: true

attribute 'ssl_certificate/cert_dir',
          display_name: 'ssl_certificate cert dir',
          description: 'Default SSL certificate directory.',
          type: 'string',
          required: 'optional',
          calculated: true

grouping 'ssl_certificate/web',
         title: 'ssl_certificate web',
         description: 'ssl_certificate web template defaults.'

attribute 'ssl_certificate/web/cipher_suite',
          display_name: 'ssl_certificate web cipher suite',
          description: 'Web template default SSL cipher suite.',
          type: 'string',
          required: 'optional',
          default: nil

grouping 'ssl_certificate/web/protocols',
         title: 'ssl_certificate web protocol',
         description: 'ssl_certificate web template SSL protocols.'

attribute 'ssl_certificate/web/protocols/nginx',
          display_name: 'ssl_certificate web protocol',
          description: 'Web template default SSL protocols for nginx.',
          type: 'string',
          required: 'optional',
          default: nil

attribute 'ssl_certificate/web/protocols/apache',
          display_name: 'ssl_certificate web protocol',
          description: 'Web template default SSL protocols for Apache httpd.',
          type: 'string',
          required: 'optional',
          default: nil

attribute 'ssl_certificate/web/compatibility',
          display_name: 'ssl_certificate web compatibility',
          description: 'Web template SSL compatibility level.',
          type: 'string',
          required: 'optional',
          default: nil

attribute 'ssl_certificate/web/use_hsts',
          display_name: 'ssl_certificate web use hsts',
          description: 'Whether to enable HSTS.',
          type: 'string',
          required: 'optional',
          default: false

attribute 'ssl_certificate/web/use_stapling',
          display_name: 'ssl_certificate web use stapling',
          description: 'Whether to enable OCSP stapling.',
          type: 'string',
          required: 'optional',
          default: false
