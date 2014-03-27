#
# Cookbook Name:: ssl_certificate_test
# Recipe:: default
#
# Copyright 2014, Onddo Labs, Sl.
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

cert1_name = 'dummy1'
node.default[cert1_name]['ssl_cert']['source'] = 'self-signed'
node.default[cert1_name]['ssl_key']['source'] = 'self-signed'
ssl_certificate cert1_name

ssl_certificate 'dummy2' do
  key_source 'self-signed'
  cert_source 'self-signed'
end

ssl_certificate 'dummy3' do
  source 'self-signed'
  years 5
end
