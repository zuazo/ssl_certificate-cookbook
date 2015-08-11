# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate_test
# Recipe:: subject_alternate_names
# Author:: Steve Meinel (<steve.meinel@caltech.edu>)
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2014 Onddo Labs, SL.
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

ssl_certificate 'subject_alternate_names1' do
  key_source 'self-signed'
  cert_source 'self-signed'
end

email = 'email@example.com'
domain1 = node['fqdn']
node.default[domain1]['ssl_cert']['subject_alternate_names'] =
  [domain1, 'foo', 'bar', 'foo.' + domain1]

ssl_certificate 'subject_alternate_names2' do
  namespace node[domain1]
  key_source 'self-signed'
  cert_source 'self-signed'
end

domain2 = "www1.#{node['fqdn']}"
node.default[domain2]['email'] = email
node.default[domain2]['ssl_cert']['subject_alternate_names'] =
  [
    'email:copy',
    "email:my@#{domain2}",
    "URI:http://#{domain2}/",
    'IP:192.168.7.1',
    'IP:13::17',
    'RID:1.2.3.4',
    'otherName:1.2.3.4;UTF8:some other identifier'
  ]

ssl_certificate 'subject_alternate_names3' do
  namespace node[domain2]
  key_source 'self-signed'
  cert_source 'self-signed'
end
