# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2016 Xabier de Zuazo
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

require_relative '../spec_helper'
require 'attribute_helpers'

describe Chef::SslCertificateCookbook::AttributeHelpers, order: :random do
  let(:helpers) { described_class }
  let(:resolv_dns_config) { instance_double('Resolv::DNS::Config') }
  let(:nameserver_port) { [%w(1.2.3.4 53)] }

  context '.resolvers' do
    before do
      expect(Resolv::DNS::Config).to receive(:new)
        .and_return(resolv_dns_config)
      allow(resolv_dns_config).to receive(:lazy_initialize)
        .and_return(resolv_dns_config)
      allow(resolv_dns_config).to receive(:nameserver_port)
        .and_return(nameserver_port)
    end

    it 'returns the DNS resolver as a string' do
      expect(helpers.resolvers).to eq('1.2.3.4:53')
    end

    context 'with multiple DNS resolvers' do
      let(:nameserver_port) { [%w(1.2.3.4 53), %w(5.6.7.8 5353)] }

      it 'returns all DNS resolvers' do
        expect(helpers.resolvers).to eq('1.2.3.4:53 5.6.7.8:5353')
      end
    end

    context 'without DNS resolvers' do
      let(:nameserver_port) { [['0.0.0.0', 53]] } # tested on GNU/Linux

      it 'returns nil' do
        expect(helpers.resolvers).to eq(nil)
      end
    end
  end
end
