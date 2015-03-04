# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate
# Recipe:: attr_apply

node['ssl_certificate']['items'].each do |item_hash|
  ssl_certificate item_hash[:name] do
    ['common_name', 'domain', 'country', 'city', 'state', 'organization',
     'department', 'email', 'time', 'years', 'owner', 'group', 'dir',
     'source', 'bag', 'item', 'encrypted', 'secret_file', 'key_path',
     'key_name', 'key_dir', 'key_source', 'key_bag', 'key_item', 'key_item_key',
     'key_encrypted', 'key_secret_file', 'key_content', 'cert_path', 'cert_name',
     'cert_dir', 'cert_source', 'cert_bag', 'cert_item', 'cert_item_key',
     'cert_encrypted', 'cert_secret_file', 'cert_content', 'subject_alternate_names',
     'chain_path', 'chain_name', 'chain_dir', 'chain_source', 'chain_bag',
     'chain_item', 'chain_item_key', 'chain_encrpted', 'chain_secret_file',
     'chain_content', 'chain_combined_name', 'chain_combined_path',
     'ca_cert_path', 'ca_key_path'].each do |attr|
      send(attr, item_hash[attr])  if item_hash[attr]
    end
  end
end
