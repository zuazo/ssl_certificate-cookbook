# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate
# Recipe:: attr_apply

node['ssl_certificate']['items'].each do |item_hash|
  ssl_certificate item_hash[:name] do
    namespace item_hash
  end
end
