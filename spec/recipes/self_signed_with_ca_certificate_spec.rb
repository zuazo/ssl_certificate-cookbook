# encoding: UTF-8
#
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

require 'spec_helper'

describe 'ssl_certificate_test::self_signed_with_ca_certificate',
         order: :random do
  let(:chef_runner) { ChefSpec::ServerRunner.new }
  let(:chef_run) { chef_runner.converge(described_recipe) }
  let(:ca_key_path) { ::File.join(Chef::Config[:file_cache_path], 'CA.key') }
  let(:ca_cert_path) { ::File.join(Chef::Config[:file_cache_path], 'CA.crt') }
  before do
    stub_command('/usr/sbin/apache2 -t').and_return(true)
  end

  it 'creates test.com certificate' do
    expect(chef_run).to create_ssl_certificate('test.com')
      .with_ca_key_path(ca_key_path)
      .with_ca_cert_path(ca_cert_path)
  end

  it 'includes apache2 recipe' do
    expect(chef_run).to include_recipe 'apache2'
  end

  it 'includes apache2::mod_ssl recipe' do
    expect(chef_run).to include_recipe 'apache2::mod_ssl'
  end

  context 'web_app test.com definition' do
    it 'creates apache2 site' do
      expect(chef_run)
        .to create_template(%r{/sites-available/test\.com\.conf$})
    end
  end

  it 'creates ca.example.org CA certificate from a data bag' do
    expect(chef_run).to create_ssl_certificate('ca.example.org')
      .with_common_name('ca.example.org')
      .with_source('data-bag')
      .with_bag('ssl')
      .with_key_item('ca_key')
      .with_key_item_key('content')
      .with_key_encrypted(true)
      .with_cert_item('ca_cert')
      .with_cert_item_key('content')
  end

  it 'creates example.org certificate from data bag CA certificate' do
    expect(chef_run).to create_ssl_certificate('example.org')
      .with_ca_cert_path('/etc/ssl/certs/ca.example.org.pem')
      .with_ca_key_path('/etc/ssl/private/ca.example.org.key')
  end

  context 'step into ssl_certificate resource' do
    let(:chef_runner) do
      ChefSpec::ServerRunner.new(step_into: %w(ssl_certificate))
    end
    let(:db_ca_key) do
      '-----BEGIN PRIVATE KEY-----[...]-----END PRIVATE KEY-----'
    end
    let(:db_ca_cert) do
      '-----BEGIN CERTIFICATE-----[...]-----END CERTIFICATE-----'
    end
    before do
      allow(Chef::EncryptedDataBagItem).to receive(:load)
        .with('ssl', 'ca_key', nil).and_return('content' => db_ca_key)
      allow(Chef::DataBagItem).to receive(:load).with('ssl', 'ca_cert')
        .and_return('content' => db_ca_cert)
    end

    it 'runs without errors' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates test.com key' do
      expect(chef_run).to create_file('test.com SSL certificate key')
        .with_path('/etc/ssl/private/test.com.key')
        .with_owner('root')
        .with_group('root')
        .with_mode(00600)
    end

    it 'creates test.com certificate' do
      expect(chef_run).to create_file('test.com SSL public certificate')
        .with_path('/etc/ssl/certs/test.com.pem')
        .with_owner('root')
        .with_group('root')
        .with_mode(00644)
    end

    it 'creates ca.example.org CA certificate key' do
      expect(chef_run).to create_file('ca.example.org SSL certificate key')
        .with_path('/etc/ssl/private/ca.example.org.key')
        .with_owner('root')
        .with_group('root')
        .with_mode(00600)
        .with_content(db_ca_key)
    end

    it 'creates ca.example.org CA certificate' do
      expect(chef_run).to create_file('ca.example.org SSL public certificate')
        .with_path('/etc/ssl/certs/ca.example.org.pem')
        .with_owner('root')
        .with_group('root')
        .with_mode(00644)
        .with_content(db_ca_cert)
    end

    it 'creates example.org key' do
      expect(chef_run).to create_file('example.org SSL certificate key')
        .with_path('/etc/ssl/private/example.org.key')
        .with_owner('root')
        .with_group('root')
        .with_mode(00600)
    end

    it 'creates example.org certificate' do
      expect(chef_run).to create_file('example.org SSL public certificate')
        .with_path('/etc/ssl/certs/example.org.pem')
        .with_owner('root')
        .with_group('root')
        .with_mode(00644)
    end
  end
end
