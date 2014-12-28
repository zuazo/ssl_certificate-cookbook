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

      def action_create
        main_resource = @new_resource
        updated_by_last_action = main_resource.updated_by_last_action?

        # install needed dependencies
        if @new_resource.depends_chef_vault?
          r = chef_gem 'chef-vault'
          updated_by_last_action ||= r.updated_by_last_action?
        end

        unless @current_resource.exist? &&
               @current_resource == @new_resource &&
               main_resource.updated_by_last_action? == false

          # Create ssl certificate key
          r = Chef::Resource::File.new(
            "#{main_resource.name} SSL certificate key",
            @new_resource.run_context
          )
          r.path(main_resource.key_path)
          r.owner('root')
          r.group('root')
          r.mode(00600)
          r.content(main_resource.key_content)
          r.action(:nothing)
          run_context.resource_collection << r
          r.run_action(:create)
          updated_by_last_action ||= r.updated_by_last_action?

          # Create ssl certificate
          r = Chef::Resource::File.new(
            "#{main_resource.name} SSL public certificate",
            @new_resource.run_context
          )
          r.path(main_resource.cert_path)
          r.owner('root')
          r.group('root')
          r.mode(00644)
          r.content(main_resource.cert_content)
          r.action(:nothing)
          run_context.resource_collection << r
          r.run_action(:create)
          updated_by_last_action ||= r.updated_by_last_action?

          # Conditionally write intermediary chain certificate
          if !main_resource.chain_name.nil? && !main_resource.chain_content.nil?
            r = Chef::Resource::File.new(
              "#{main_resource.name} SSL intermediary chain certificate",
              @new_resource.run_context
            )
            r.path(main_resource.chain_path)
            r.owner('root')
            r.group('root')
            r.mode(00644)
            r.content(main_resource.chain_content)
            r.action(:nothing)
            run_context.resource_collection << r
            r.run_action(:create)
            updated_by_last_action ||= r.updated_by_last_action?
          end

        end

        main_resource.updated_by_last_action(updated_by_last_action)
      end
    end
  end
end
