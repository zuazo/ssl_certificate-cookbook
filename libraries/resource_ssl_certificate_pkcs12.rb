# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate
# Library:: resource_ssl_certificate_pkcs12
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Copyright:: Copyright (c) 2015 Criteo
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

require 'chef/resource'

# Chef configuration management tool main class.
class Chef
  # Chef Resource describes the desired state of an element of your
  # infrastructure.
  class Resource
    class SslCertificate < Chef::Resource
      # ssl_certificate Chef Resource PKCS12 related methods.
      module PKCS12
        # Resource key attributes to be initialized by a `default_#{attribute}`
        # method.
        unless defined?(::Chef::Resource::SslCertificate::PKCS12::ATTRS)
          ATTRS = %w(
            pkcs12_path
            pkcs12_passphrase
          )
        end

        public

        def initialize_pkcs12_defaults
          initialize_attribute_defaults(PKCS12::ATTRS)
        end

        # PKCS12 public methods

        def generate_pkcs12(name, key_content, cert_content,
          pkcs12_passphrase = nil, key_passphrase = nil)
          key = OpenSSL::PKey.read key_content, key_passphrase
          crt = OpenSSL::X509::Certificate.new cert_content
          OpenSSL::PKCS12.create(pkcs12_passphrase, name, key, crt)
        end

        def pkcs12
          @pkcs12 ||= generate_pkcs12 name, key_content, cert_content,
                                      pkcs12_passphrase
        end

        def pkcs12_path(arg = nil)
          set_or_return(:pkcs12_path, arg, kind_of: String)
        end

        def pkcs12_passphrase(arg = nil)
          set_or_return(:pkcs12_passphrase, arg, kind_of: String)
        end

        protected

        def default_pkcs12_path
          lazy { read_namespace(%w(pkcs12_path)) }
        end

        def default_pkcs12_passphrase
          lazy { read_namespace(%w(pkcs12_passphrase)) }
        end
      end
    end
  end
end
