# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate
# Resource:: ssl_certificate
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
    # Helper methods to use from templates.
    #
    # These methods should be included in the template using class `include`.
    #
    # @example
    #   self.class.send(:include, Chef::SslCertificateCookbook::TemplateHelpers)
    #   @ssl_config = ssl_config('apache')
    module TemplateHelpers
      protected

      def ssl_compatibility
        if @ssl_compatibility.is_a?(String) || @ssl_compatibility.is_a?(Symbol)
          @ssl_compatibility
        else
          node['ssl_certificate']['web']['compatibility']
        end
      end

      def ssl_compatibility_set?
        (ssl_compatibility.is_a?(String) ||
          ssl_compatibility.is_a?(Symbol)) &&
          node['ssl_certificate']['web'][ssl_compatibility].is_a?(Hash)
      end

      def ssl_config_merge!(hs1, hs2)
        Chef::Mixin::DeepMerge.hash_only_merge!(hs1, hs2)
      end

      def ssl_config_default
        node['ssl_certificate']['web'].dup
      end

      def ssl_config_compatibility
        unless ssl_compatibility_set? &&
               node['ssl_certificate']['web'][ssl_compatibility].is_a?(Hash)
          return Mash.new
        end
        node['ssl_certificate']['web'][ssl_compatibility]
      end

      def ssl_config_web(ssl_config, web_service)
        return Mash.new unless ssl_config[web_service].is_a?(Hash)
        ssl_config.delete(web_service)
      end

      def generate_ssl_config(web_service)
        config = ssl_config_default
        ssl_config_merge!(config, ssl_config_compatibility)
        config_web = ssl_config_web(config, web_service)
        ssl_config_merge!(config, config_web)
      end

      public

      def ssl_config(web_service)
        generate_ssl_config(web_service)
      end
    end
  end
end
