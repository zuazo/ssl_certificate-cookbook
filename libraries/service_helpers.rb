# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate
# Library:: service_helpers
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2015 Onddo Labs, SL. (www.onddo.com)
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

# Chef configuration management tool main class.
class Chef
  module SslCertificateCookbook
    # Helper methods to configure SSL Services specific parameters.
    #
    # These methods should be included in the template using class `include`.
    #
    # @example
    #   self.class.send(:include, Chef::SslCertificateCookbook::ServiceHelpers)
    #   @ssl_config = ssl_config_for_service('apache')
    module ServiceHelpers
      protected

      def ssl_config_merge(hs1, hs2)
        Chef::Mixin::DeepMerge.hash_only_merge(hs1.dup, hs2.dup)
      end

      def ssl_config_merge!(hs1, hs2)
        Chef::Mixin::DeepMerge.hash_only_merge!(hs1, hs2)
      end

      def deprecated_config_merge
        node.default['ssl_certificate']['service'] = ssl_config_merge(
          node['ssl_certificate']['service'],
          node['ssl_certificate']['web']
        )
      end

      def deprecated_config_check
        return if node['ssl_certificate']['web'].empty?
        Chef::Log.warn(
          '[DEPRECATED] Use '\
          "`node['ssl_certificate']['service']['compatibility']` instead of "\
          "`node['ssl_certificate']['web']['compatibility']`."
        )
        deprecated_config_merge
      end

      def ssl_compatibility
        if @ssl_compatibility.is_a?(String) || @ssl_compatibility.is_a?(Symbol)
          @ssl_compatibility
        else
          node['ssl_certificate']['service']['compatibility']
        end
      end

      def ssl_compatibility_set?
        (ssl_compatibility.is_a?(String) ||
          ssl_compatibility.is_a?(Symbol)) &&
          node['ssl_certificate']['service'][ssl_compatibility].is_a?(Hash)
      end

      def ssl_config_default
        node['ssl_certificate']['service'].dup
      end

      def ssl_config_compatibility
        unless ssl_compatibility_set? &&
               node['ssl_certificate']['service'][ssl_compatibility].is_a?(Hash)
          return Mash.new
        end
        node['ssl_certificate']['service'][ssl_compatibility]
      end

      def ssl_config_service(ssl_config, service)
        return Mash.new unless ssl_config[service].is_a?(Hash)
        ssl_config.delete(service)
      end

      public

      def default_ssl_config
        deprecated_config_check
        config = ssl_config_default
        ssl_config_merge!(config, ssl_config_compatibility)
      end

      def ssl_config_for_service(service)
        config = default_ssl_config
        config_service = ssl_config_service(config, service)
        ssl_config_merge!(config, config_service)
      end

      def nginx_version
        return nil unless node.key?('nginx')
        node['nginx']['version']
      end

      def nginx_version_satisfies?(requirement)
        return false if nginx_version.nil?
        version = Gem::Version.new(nginx_version)
        Gem::Requirement.new(requirement).satisfied_by?(version)
      end
    end
  end
end
