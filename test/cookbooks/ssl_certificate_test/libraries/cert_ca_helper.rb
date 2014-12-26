# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate_test
# Library:: cert_ca_helper
# Description:: Library to create Certificate Authority.
# Author:: Jeremy MAURO (j.mauro@criteo.com)
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

# Helper module to create Certificate Authority certificates.
module CACertificate
  require 'openssl'

  def self.ca_key(ca_key_file = '/etc/pki/tls/private/ca_key.pem',
      pass_phrase = nil)
    ca_key = OpenSSL::PKey::RSA.new 2048
    if pass_phrase
      cipher = OpenSSL::Cipher::Cipher.new 'AES-128-CBC'

      open ca_key_file, 'w', 0400 do |io|
        io.write ca_key.export(cipher, pass_phrase)
      end
    else
      open ca_key_file, 'w', 0400 do |io|
        io.write ca_key.to_pem
      end
    end
  end

  def self.ca_certificate(name = 'CN=ca/DC=example',
      ca_key_file = '/etc/pki/tls/private/ca_key.pem',
      ca_cert_file = '/etc/pki/tls/certs/ca_cert.pem', time = 86_400)
    ca_name = name
    ca_key  = OpenSSL::PKey::RSA.new File.read(ca_key_file)
    ca_cert = OpenSSL::X509::Certificate.new

    ca_cert.serial     = 0
    ca_cert.version    = 2
    ca_cert.not_before = Time.now
    ca_cert.not_after  = Time.now + time.to_i

    ca_cert.public_key = ca_key.public_key
    ca_cert.subject    = ca_name
    ca_cert.issuer     = ca_name

    extension_factory                     = OpenSSL::X509::ExtensionFactory.new
    extension_factory.subject_certificate = ca_cert
    extension_factory.issuer_certificate  = ca_cert

    ca_cert.add_extension \
      extension_factory.create_extension('subjectKeyIdentifier', 'hash')
    ca_cert.add_extension \
      extension_factory.create_extension('basicConstraints', 'CA:TRUE', true)
    ca_cert.add_extension \
      extension_factory.create_extension(
        'keyUsage', 'cRLSign,keyCertSign', true
      )

    ca_cert.sign ca_key, OpenSSL::Digest::SHA1.new
    open ca_cert_file, 'w' do |io|
      io.write ca_cert.to_pem
    end
  end

  def self.generate_cert_subject(s)
    name =
      if s.is_a?(Hash)
        n = []
        unless s['country'].nil?
          n.push(['C', s['country'].to_s, OpenSSL::ASN1::PRINTABLESTRING])
        end
        unless s['state'].nil?
          n.push(['ST', s['state'].to_s, OpenSSL::ASN1::PRINTABLESTRING])
        end
        unless s['city'].nil?
          n.push(['L', s['city'].to_s, OpenSSL::ASN1::PRINTABLESTRING])
        end
        unless s['organization'].nil?
          n.push(['O', s['organization'].to_s, OpenSSL::ASN1::UTF8STRING])
        end
        unless s['department'].nil?
          n.push(['OU', s['department'].to_s, OpenSSL::ASN1::UTF8STRING])
        end
        unless s['common_name'].nil?
          n.push(['CN', s['common_name'].to_s, OpenSSL::ASN1::UTF8STRING])
        end
        unless s['email'].nil?
          n.push(
            ['emailAddress', s['email'].to_s, OpenSSL::ASN1::UTF8STRING]
          )
        end
        n
      else
        [['CN', s.to_s, OpenSSL::ASN1::UTF8STRING]]
      end
    OpenSSL::X509::Name.new(name)
  end
end
