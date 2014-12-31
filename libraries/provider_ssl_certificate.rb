# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate
# Provider:: ssl_certificate
# Author:: Raul Rodriguez (<raul@onddo.com>)
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Author:: Steve Meinel (<steve.meinel@caltech.edu>)
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

require 'chef/provider'

# Chef configuration management tool main class.
class Chef
  # Chef provider defines the steps that are needed to bring that piece of the
  # system from its current state into the desired state.
  class Provider
    # Chef Provider for ssl_certificate Resource.
    class SslCertificate < Chef::Provider
      def load_current_resource
        @current_resource ||=
          Chef::Resource::SslCertificate.new(@new_resource.name, run_context)
        @current_resource.load
        @current_resource
      end

      def install_chef_vault
        return unless new_resource.depends_chef_vault?
        r = chef_gem 'chef-vault'
        new_resource.updated_by_last_action(r.updated_by_last_action?)
      end

      def file(name, &resource_attrs_block)
        resource = Chef::Resource::File.new(name, new_resource.run_context)
        resource.owner(node['ssl_certificate']['user'])
        resource.group(node['ssl_certificate']['group'])
        resource.instance_eval(&resource_attrs_block) if block_given?
        resource.action(:nothing)
        resource
      end

      def file_create(desc, f_path, f_content, f_mode = 00644)
        resource = file("#{new_resource.name} #{desc}") do
          path f_path
          content f_content
          mode f_mode
        end
        run_context.resource_collection << resource
        resource.run_action(:create)
        new_resource.updated_by_last_action(resource.updated_by_last_action?)
        resource
      end

      def create_key
        file_create(
          'SSL certificate key',
          new_resource.key_path, new_resource.key_content, 00600
        )
      end

      def create_cert
        file_create(
          'SSL public certificate',
          new_resource.cert_path, new_resource.cert_content
        )
      end

      def create_chain?
        !new_resource.chain_name.nil? && !new_resource.chain_content.nil?
      end

      def create_chain
        file_create(
          'SSL intermediary chain certificate',
          new_resource.chain_path, new_resource.chain_content
        )
      end

      def current_resource_updated?(new_resource_updated)
        @current_resource.exist? &&
          @current_resource == new_resource &&
          new_resource_updated == false
      end

      def action_create
        new_resource_updated = new_resource.updated_by_last_action?
        install_chef_vault
        return if current_resource_updated?(new_resource_updated)
        create_key
        create_cert
        create_chain if create_chain?
      end
    end
  end
end
