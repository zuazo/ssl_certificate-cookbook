#
# Cookbook Name::	docker-registry
# Description::		Library to create Certificate Authority
# Recipe::				docker_certificate_helper
# Author::        Jeremy MAURO (j.mauro@criteo.com)
#
#
#

module CACertificate
  require 'openssl'

  def self.ca_key(ca_key_file = '/etc/pki/tls/private/ca_key.pem', pass_phrase = nil)
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

  def self.ca_certificate(name = 'CN=ca/DC=example', ca_key_file = '/etc/pki/tls/private/ca_key.pem', ca_cert_file = '/etc/pki/tls/certs/ca_cert.pem', time = 86400)
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
      extension_factory.create_extension('keyUsage', 'cRLSign,keyCertSign', true)

    ca_cert.sign ca_key, OpenSSL::Digest::SHA1.new
    open ca_cert_file, 'w' do |io|
      io.write ca_cert.to_pem
    end
  end

  def self.generate_cert_subject(s)
    name = if s.kind_of?(Hash)
      n = []
      n.push(['C', s['country'].to_s, OpenSSL::ASN1::PRINTABLESTRING]) unless s['country'].nil?
      n.push(['ST', s['state'].to_s, OpenSSL::ASN1::PRINTABLESTRING]) unless s['state'].nil?
      n.push(['L', s['city'].to_s, OpenSSL::ASN1::PRINTABLESTRING]) unless s['city'].nil?
      n.push(['O', s['organization'].to_s, OpenSSL::ASN1::UTF8STRING]) unless s['organization'].nil?
      n.push(['OU', s['department'].to_s, OpenSSL::ASN1::UTF8STRING]) unless s['department'].nil?
      n.push(['CN', s['common_name'].to_s, OpenSSL::ASN1::UTF8STRING]) unless s['common_name'].nil?
      n.push(['emailAddress', s['email'].to_s, OpenSSL::ASN1::UTF8STRING]) unless s['email'].nil?
      n
    else
      [['CN', s.to_s, OpenSSL::ASN1::UTF8STRING]]
    end
    OpenSSL::X509::Name.new(name)
  end
end
