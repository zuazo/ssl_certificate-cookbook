# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate
# Library:: resource_ssl_certificate_readers
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
require 'openssl'

class Chef
  class Resource
    # ssl_certificate Chef Resource.
    class SslCertificate < Chef::Resource
      # ssl_certificate Chef Resource methods to read from differente sources.
      module Readers
        protected

        # Read some values from node namespace avoiding exceptions.
        def read_namespace(ary)
          ary = [ary].flatten
          # TODO: Check ary parameter value.
          ary.inject(namespace) do |n, k|
            n.respond_to?(:key?) && n.key?(k) ? n[k] : nil
          end
        end

        def read_from_path(path)
          return nil unless ::File.exist?(path)
          ::IO.read(path)
        end

        def read_from_data_bag(bag, item, key, encrypt = false, secret = nil)
          if encrypt
            item = Chef::EncryptedDataBagItem.load(bag, item, secret)
          else
            item = Chef::DataBagItem.load(bag, item)
          end
          item[key.to_s]
        rescue StandardError => e
          Chef::Log.error(e.message)
          Chef::Log.error("Backtrace:\n#{e.backtrace.join("\n")}\n")
          nil
        end

        def read_from_chef_vault(bag, item, item_key)
          require 'chef-vault'

          begin
            item = ChefVault::Item.load(bag, item)
            item[item_key.to_s]
          rescue StandardError => e
            Chef::Log.error(e.message)
            Chef::Log.error("Backtrace:\n#{e.backtrace.join("\n")}\n")
            nil
          end
        end
      end
    end
  end
end
