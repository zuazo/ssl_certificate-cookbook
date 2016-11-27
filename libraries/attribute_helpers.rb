# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate
# Library:: attribute_helpers
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

require 'resolv'

class Chef
  module SslCertificateCookbook
    # Helper methods to use from attribute files.
    #
    # Usage example:
    #
    # ```ruby
    # # attributes/whatever.rb
    # Chef::SslCertificateCookbook::AttributeHelpers.resolvers
    #   #=> "8.8.8.8:53"
    # ```
    class AttributeHelpers
      # Returns the system DNS resolvers separated by spaces.
      #
      # @return [String, nil] The DNS resolver address.
      # @example
      #   resolvers #=> "8.8.8.8:53 4.4.4.2:53"
      # @api public
      def self.resolvers
        empty_ary = [nil, [], [[]], [['0.0.0.0', 53]]]
        resolvers = Resolv::DNS::Config.new.lazy_initialize.nameserver_port
        return nil if empty_ary.include?(resolvers)
        resolvers.map { |x| x.join(':') }.join(' ')
      end
    end
  end
end
