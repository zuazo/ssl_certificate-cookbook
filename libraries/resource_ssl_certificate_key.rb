# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate
# Library:: resource_ssl_certificate_key
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

require 'chef/resource'

class Chef
  class Resource
    class SslCertificate < Chef::Resource
      # ssl_certificate Chef Resource key related methods.
      module Key
        # Resource key attributes to be initialized by a `default#{attribute}`
        # method.
        unless defined?(::Chef::Resource::SslCertificate::Key::ATTRIBUTES)
          ATTRIBUTES = %w(
            key_name
            key_dir
            key_path
            key_source
            key_bag
            key_item
            key_item_key
            key_encrypted
            key_secret_file
            key_content
          )
        end

        unless defined?(::Chef::Resource::SslCertificate::Key::SOURCES)
          SOURCES = %w(
            attribute
            data_bag
            chef_vault
            file
            self_signed
          )
        end

        public

        def initialize_key_defaults
          ::Chef::Resource::SslCertificate::Key::ATTRIBUTES.each do |var|
            instance_variable_set(
              "@#{var}".to_sym, send("default_#{var}")
            )
          end
        end

        def key_name(arg = nil)
          set_or_return(:key_name, arg, kind_of: String, required: true)
        end

        def key_dir(arg = nil)
          set_or_return(:key_dir, arg, kind_of: String)
        end

        def key_path(arg = nil)
          set_or_return(:key_path, arg, kind_of: String, required: true)
        end

        def key_source(arg = nil)
          set_or_return(:key_source, arg, kind_of: String)
        end

        def key_bag(arg = nil)
          set_or_return(:key_bag, arg, kind_of: String)
        end

        def key_item(arg = nil)
          set_or_return(:key_item, arg, kind_of: String)
        end

        def key_item_key(arg = nil)
          set_or_return(:key_item_key, arg, kind_of: String)
        end

        def key_encrypted(arg = nil)
          set_or_return(:key_encrypted, arg, kind_of: [TrueClass, FalseClass])
        end

        def key_secret_file(arg = nil)
          set_or_return(:key_secret_file, arg, kind_of: String)
        end

        def key_content(arg = nil)
          set_or_return(:key_content, arg, kind_of: String)
        end

        protected

        def default_key_name
          "#{name}.key"
        end

        def default_key_dir
          case node['platform']
          when 'debian', 'ubuntu'
            '/etc/ssl/private'
          when 'redhat', 'centos', 'fedora', 'scientific', 'amazon'
            '/etc/pki/tls/private'
          else
            '/etc'
          end
        end

        def default_key_path
          lazy { @default_key_path ||= ::File.join(key_dir, key_name) }
        end

        def default_key_source
          lazy { read_namespace(%w(ssl_key source)) || default_source }
        end

        def default_key_bag
          lazy { read_namespace(%w(ssl_key bag)) || read_namespace('bag') }
        end

        def default_key_item
          lazy { read_namespace(%w(ssl_key item)) || read_namespace('item') }
        end

        def default_key_item_key
          lazy { read_namespace(%w(ssl_key item_key)) }
        end

        def default_key_encrypted
          lazy do
            read_namespace(%w(ssl_key encrypted)) || read_namespace('encrypted')
          end
        end

        def default_key_secret_file
          lazy do
            read_namespace(%w(ssl_key secret_file)) ||
              read_namespace('secret_file')
          end
        end

        def default_key_content_from_attribute
          content = read_namespace(%w(ssl_key content))
          unless content.is_a?(String)
            fail 'Cannot read SSL key from content key value'
          end
          content
        end

        def default_key_content_from_data_bag
          content = read_from_data_bag(
            key_bag, key_item, key_item_key, key_encrypted, key_secret_file
          )
          unless content.is_a?(String)
            fail 'Cannot read SSL key from data bag: '\
                 "#{key_bag}.#{key_item}->#{key_item_key}"
          end
          content
        end

        def default_key_content_from_chef_vault
          content = read_from_chef_vault(key_bag, key_item, key_item_key)
          unless content.is_a?(String)
            fail 'Cannot read SSL key from chef-vault: '\
                 "#{key_bag}.#{key_item}->#{key_item_key}"
          end
          content
        end

        def default_key_content_from_file
          content = read_from_path(key_path)
          unless content.is_a?(String)
            fail "Cannot read SSL key from path: #{key_path}"
          end
          content
        end

        def default_key_content_from_self_signed
          content = read_from_path(key_path)
          unless content.is_a?(String)
            content = generate_key
            updated_by_last_action(true)
          end
          content
        end

        def default_key_content
          lazy do
            @default_key_content ||= begin
              source = key_source.gsub('-', '_')
              unless Key::SOURCES.include?(source)
                fail "Cannot read SSL key, unknown source: #{key_source}"
              end
              send("default_key_content_from_#{source}")
            end # @default_key_content ||=
          end # lazy
        end
      end
    end
  end
end
