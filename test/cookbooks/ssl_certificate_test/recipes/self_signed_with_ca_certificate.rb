# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate_test
# Recipe:: self_signed_with_ca_certificate
# Description::	 Test kitchen test for testing self-signed host with CA.
# Author:: Jeremy MAURO (<j.mauro@criteo.com>)
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2014-2015 Onddo Labs, SL.
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

ca_cert = ::File.join(node['ssl_certificate']['cert_dir'], 'CA.crt')
ca_key = ::File.join(node['ssl_certificate']['key_dir'], 'CA.key')

node.default['test.com']['common_name'] = 'test.com'
node.default['test.com']['country'] = 'FR'
node.default['test.com']['city'] = 'Paris'
node.default['test.com']['state'] = 'Ile de Paris'
node.default['test.com']['organization'] = 'Toto'
node.default['test.com']['department'] = 'Titi'
node.default['test.com']['email'] = 'titi@test.com'
node.default['test.com']['ssl_key']['source'] = 'self-signed'
node.default['test.com']['ssl_cert']['source'] = 'with_ca'

node.default['ca-certificate']['common_name'] = 'ca.test.com'
node.default['ca-certificate']['country'] = 'FR'
node.default['ca-certificate']['city'] = 'Paris'
node.default['ca-certificate']['state'] = 'Ile de Paris'
node.default['ca-certificate']['organization'] = 'Toto'
node.default['ca-certificate']['department'] = 'Titi'
node.default['ca-certificate']['email'] = 'titi@test.com'
node.default['ca-certificate']['time'] = 10 * 365

::CACertificate.key_to_file(ca_key)
::CACertificate.ca_cert_to_file(
  node['ca-certificate'], ca_key, ca_cert, node['ca-certificate']['time']
)

cert = ssl_certificate 'test.com' do
  namespace node['test.com']
  ca_cert_path ca_cert
  ca_key_path ca_key
end

include_recipe 'apache2'
include_recipe 'apache2::mod_ssl'

web_app 'test.com' do
  cookbook 'ssl_certificate'
  docroot node['apache']['docroot_dir']
  server_name cert.common_name
  ssl_key cert.key_path
  ssl_cert cert.cert_path
  ssl_compatibility :modern
  extra_directives EnableSendfile: 'On'
end

# Create a certificate from a secured CA

sec_ca_cert = ::File.join(node['ssl_certificate']['cert_dir'], 'sec_CA.crt')
sec_ca_key = ::File.join(node['ssl_certificate']['key_dir'], 'sec_CA.key')
sec_ca_pwd = 'mySecretPassPhrase'
sec_ca_info = {
  'common_name' => 'ca.secure.com',
  'country' => 'FR',
  'city' => 'Paris',
  'state' => 'Ile de Paris',
  'organization' => 'Toto',
  'department' => 'Titi',
  'email' => 'titi@secure.com',
  'time' => 10 * 365,
}

::CACertificate.key_to_file(sec_ca_key, sec_ca_pwd)
::CACertificate.ca_cert_to_file(
  sec_ca_info, sec_ca_key, sec_ca_cert, sec_ca_info['time'], sec_ca_pwd
)

ssl_certificate 'secured.test.com' do
  namespace node['test.com']
  common_name 'secured.test.com'
  ca_cert_path sec_ca_cert
  ca_key_path sec_ca_key
  ca_key_passphrase sec_ca_pwd
end

# Create the CA from an encrypted data bag

ca_cert2 = ssl_certificate 'ca.example.org' do
  common_name 'ca.example.org'
  source 'data-bag'
  bag 'ssl'
  key_item 'ca_key'
  key_item_key 'content'
  key_encrypted true
  cert_item 'ca_cert'
  cert_item_key 'content'
end

ssl_certificate 'example.org' do
  cert_source 'with_ca'
  ca_cert_path ca_cert2.cert_path
  ca_key_path ca_cert2.key_path
end
