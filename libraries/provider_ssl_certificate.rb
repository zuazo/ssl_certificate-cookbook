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

class Chef
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

      def file_create(name, &resource_attrs_block)
        resource = Chef::Resource::File.new(name, new_resource.run_context)
        resource.instance_eval(&resource_attrs_block) if block_given?
        resource.action(:nothing)
        run_context.resource_collection << resource
        resource.run_action(:create)
        new_resource.updated_by_last_action(resource.updated_by_last_action?)
        resource
      end

      def create_key
        main_resource = new_resource
        file_create "#{main_resource.name} SSL certificate key" do
          path main_resource.key_path
          owner 'root'
          group 'root'
          mode 00600
          content main_resource.key_content
        end
      end

      def create_cert
        main_resource = new_resource
        file_create "#{main_resource.name} SSL public certificate" do
          path main_resource.cert_path
          owner 'root'
          group 'root'
          mode 00644
          content main_resource.cert_content
        end
      end

      def create_chain?
        !new_resource.chain_name.nil? && !new_resource.chain_content.nil?
      end

      def create_chain
        main_resource = new_resource
        file_create "#{main_resource.name} SSL intermediary chain certificate" \
                    do
          path main_resource.chain_path
          owner 'root'
          group 'root'
          mode 00644
          content main_resource.chain_content
        end
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
