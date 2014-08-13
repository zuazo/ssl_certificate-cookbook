Description
===========
[![Cookbook Version](https://img.shields.io/cookbook/v/ssl_certificate.svg?style=flat)](https://supermarket.getchef.com/cookbooks/ssl_certificate)

The main purpose of this cookbook is to make it easy for other cookbooks to support SSL. With the resource included, you will be able to manage certificates reading them from attributes, data bags or chef-vaults. Exposing its configuration through node attributes.

Much of the code in this cookbook is heavily based on the SSL implementation from the [owncloud](http://community.opscode.com/cookbooks/owncloud) cookbook.

Requirements
============

Works on any platform with OpenSSL Ruby bindings installed, which are a requirement for Chef anyway.

Resources
=========

## ssl_certificate

Creates a SSL certificate.

By default the resource will create a self-signed certificate, but a custom one can also be used. The custom certificate can be read from several sources:

* Attribute
* Data Bag
* Encrypted Data Bag
* Chef Vault
* File

### ssl_certificate actions

* `create`: Creates the SSL certificate.

### ssl_certificate attributes

<table>
  <tr>
    <th>Attribute</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td>namespace</td>
    <td>Node namespace to read the default values from, something like <code>node["myapp"]</code>. See the documentation below for more information on how to use the namespace.</td>
    <td><code>{}</code></td>
  </tr>
  <tr>
    <td>common_name</td>
    <td>Server name or <em>Common Name</em>, used for self-signed certificates.</td>
    <td><code>namespace["common_name"]</code></td>
  </tr>
  <tr>
    <td>domain</td>
    <td><code>common_name</code> method alias.</td>
    <td><code>namespace["common_name"]</code></td>
  </tr>
  <tr>
    <td>country</td>
    <td><em>Country</em>, used for self-signed certificates.</td>
    <td><code>namespace["country"]</code></td>
  </tr>
  <tr>
    <td>city</td>
    <td><em>City</em>, used for self-signed certificates.</td>
    <td><code>namespace["city"]</code></td>
  </tr>
  <tr>
    <td>state</td>
    <td><em>State</em> or <em>Province</em> name, used for self-signed certificates.</td>
    <td><code>namespace["state"]</code></td>
  </tr>
  <tr>
    <td>organization</td>
    <td><em>Organization</em> or <em>Company</em> name, used for self-signed certificates.</td>
    <td><code>namespace["city"]</code></td>
  </tr>
  <tr>
    <td>department</td>
    <td>Department or <em>Organizational Unit</em>, used for self-signed certificates.</td>
    <td><code>namespace["city"]</code></td>
  </tr>
  <tr>
    <td>email</td>
    <td><em>Email</em> address, used for self-signed certificates.</td>
    <td><code>namespace["email"]</code></td>
  </tr>
  <tr>
    <td>time</td>
    <td>Attribute for setting self-signed certificate validity time in seconds or <code>Time</code> object instance.</td>
    <td><code>10 * 365 * 24 * 60 * 60</code></td>
  </tr>
  <tr>
    <td>years</td>
    <td>Write only attribute for setting self-signed certificate validity period in years.</td>
    <td><code>10</code></td>
  </tr>
  <tr>
    <td>dir</td>
    <td>Write only attribute for setting certificate path and key path (both) to a directory (<code>key_dir</code> and <code>cert_dir</code>).</td>
    <td><code>nil</code></td>
  </tr>
  <tr>
    <td>source</td>
    <td>Write only attribute for setting certificate source and key source (both) to a value (<code>key_source</code> and <code>cert_source</code>). Can be <code>"self-signed"</code>, <code>"attribute"</code>, <code>"data-bag"</code>, <code>"chef-vault"</code> or <code>"file"</code>.</td>
    <td><code>nil</code></td>
  </tr>
  <tr>
    <td>bag</td>
    <td>Write only attribute for setting certificate bag and key bag (both) to a value (<code>key_bag</code> and <code>cert_bag</code>).</td>
    <td><code>nil</code></td>
  </tr>
  <tr>
    <td>item</td>
    <td>Write only attribute for setting certificate item name and key bag item name (both) to a value (<code>key_item</code> and <code>cert_item</code>).</td>
    <td><code>nil</code></td>
  </tr>
  <tr>
    <td>encryption</td>
    <td>Write only attribute for setting certificate encryption and key encryption (both) to a value (<code>key_encryption</code> and <code>cert_encryption</code>).</td>
    <td><code>nil</code></td>
  </tr>
  <tr>
    <td>secret_file</td>
    <td>Write only attribute for setting certificate chef secret file and key chef secret file (both) to a value (<code>key_secret_file</code> and <code>cert_secret_file</code>).</td>
    <td><code>nil</code></td>
  </tr>
  <tr>
    <td>key_path</td>
    <td>Private key full path.</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td>key_name</td>
    <td>Private key file name.</td>
    <td><code>"#{name}.key"</code></td>
  </tr>
  <tr>
    <td>key_dir</td>
    <td>Private key directory path.</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td>key_source</td>
    <td>Source type to get the SSL key from. Can be <code>"self-signed"</code>, <code>"attribute"</code>, <code>"data-bag"</code>, <code>"chef-vault"</code> or <code>"file"</code>.</td>
    <td><code>"self-signed"</code></td>
  </tr>
  <tr>
    <td>key_bag</td>
    <td>Name of the Data Bag where the SSL key is stored.</td>
    <td><code>namespace["ssl_key"]["bag"]</code></td>
  </tr>
  <tr>
    <td>key_item</td>
    <td>Name of the Data Bag Item where the SSL key is stored.</td>
    <td><code>namespace["ssl_key"]["item"]</code></td>
  </tr>
  <tr>
    <td>key_item_key</td>
    <td>Key of the Data Bag Item where the SSL key is stored.</td>
    <td><code>namespace["ssl_key"]["item_key"]</code></td>
  </tr>
  <tr>
    <td>key_encrypted</td>
    <td>Whether the Data Bag where the SSL key is stored is encrypted.</td>
    <td><code>false</code></td>
  </tr>
  <tr>
    <td>key_secret_file</td>
    <td>Secret file used to decrypt the Data Bag where the SSL key is stored.</td>
    <td><code>nil</code></td>
  </tr>
  <tr>
    <td>key_content</td>
    <td>SSL key file content in clear. <strong>Be careful when using it.<strong></td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td>cert_path</td>
    <td>Private cert full path.</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td>cert_name</td>
    <td>Private cert file name.</td>
    <td><code>"#{name}.pem"</code></td>
  </tr>
  <tr>
    <td>cert_dir</td>
    <td>Private cert directory path.</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td>cert_source</td>
    <td>Source type to get the SSL cert from. Can be <code>"self-signed"</code>, <code>"attribute"</code>, <code>"data-bag"</code>, <code>"chef-vault"</code> or <code>"file"</code>.</td>
    <td><code>"self-signed"</code></td>
  </tr>
  <tr>
    <td>cert_bag</td>
    <td>Name of the Data Bag where the SSL cert is stored.</td>
    <td><code>namespace["ssl_cert"]["bag"]</code></td>
  </tr>
  <tr>
    <td>cert_item</td>
    <td>Name of the Data Bag Item where the SSL cert is stored.</td>
    <td><code>namespace["ssl_cert"]["item"]</code></td>
  </tr>
  <tr>
    <td>cert_item_cert</td>
    <td>Cert of the Data Bag Item where the SSL cert is stored.</td>
    <td><code>namespace["ssl_cert"]["item_cert"]</code></td>
  </tr>
  <tr>
    <td>cert_encrypted</td>
    <td>Whether the Data Bag where the SSL cert is stored is encrypted.</td>
    <td><code>false</code></td>
  </tr>
  <tr>
    <td>cert_secret_file</td>
    <td>Secret file used to decrypt the Data Bag where the SSL cert is stored.</td>
    <td><code>nil</code></td>
  </tr>
  <tr>
    <td>cert_content</td>
    <td>SSL cert file content in clear.</td>
    <td><em>calculated</em></td>
  </tr>
</table>

Templates
=========

This cookbook includes a simple VirtualHost template which can be used by the `web_app` definition from the [apache2](http://community.opscode.com/cookbooks/apache2) cookbook:

```ruby
cert = ssl_certificate "my-webapp" do
  namespace node["my-webapp"]
  notifies :restart, "service[apache2]"
end

include_recipe "apache2"
include_recipe "apache2::mod_ssl"
web_app "my-webapp" do
  cookbook "ssl_certificate"
  server_name cert.common_name
  docroot # [...]
  # [...]
  ssl_key cert.key_path
  ssl_cert cert.cert_path
end
```

Usage
=====

## Including the cookbook

You need to include this recipe in your `run_list` before using the  `ssl_certificate` resource:

```json
{
  "name": "onddo.com",
  [...]
  "run_list": [
    [...]
    "recipe[ssl_certificate]"
  ]
}
```

You can also include the cookbook as a dependency in the metadata of your cookbook:

```ruby
# metadata.rb
depends "ssl_certificate"
```

One of the two is enough. No need to do anything else. Only use the `ssl_certificate` resource to create the certificates you need.

## A Short Example

```ruby
cert = ssl_certificate "webapp1" do
  namespace node["webapp1"] # optional but recommended
end
# you can now use the #cert_path and #key_path methods to use in your web/mail/ftp service configurations
log "WebApp1 certificate is here: #{cert.cert_path}"
log "WebApp1 private key is here: #{cert.key_path}"
```

## Namespaces

The `ssl_certificate` **namespace** attribute is a node attribute path, like for example `node["onddo.com"]`, used to configure SSL certificate defaults. This will make easier to *integrate the node attributes* with the certificate creation matters. This means you can configure the certificate creation through node attributes.

When a namespace is set in the resource, it will try to read the following attributes below the namespace (all attributes are **optional**):

<table>
  <tr>
    <th>Attribute</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><code>namespace["common_name"]</code></td>
    <td>Server name or *Common Name*, used for self-signed certificates (uses <code>node["fqdn"]</code> by default).</td>
  </tr>
  <tr>
    <td><code>namespace["country"]</code></td>
    <td><em>Country</em>, used for self-signed certificates.</td>
  </tr>
  <tr>
    <td><code>namespace["city"]</code></td>
    <td><em>City</em>, used for self-signed certificates.</td>
  </tr>
  <tr>
    <td><code>namespace["state"]</code></td>
    <td><em>State</em> or <em>Province</em> name, used for self-signed certificates.</td>
  </tr>
  <tr>
    <td><code>namespace["organization"]</code></td>
    <td><em>Organization</em> or <em>Company</em> name, used for self-signed certificates.</td>
  </tr>
  <tr>
    <td><code>namespace["department"]</code></td>
    <td>Department or <em>Organizational Unit</em>, used for self-signed certificates.</td>
  </tr>
  <tr>
    <td><code>namespace["email"]</code></td>
    <td><em>Email</em> address, used for self-signed certificates.</td>
  </tr>
  <tr>
    <td><code>namespace["bag"]</code></td>
    <td>Attribute for setting certificate bag and key bag (both) to a value (<code>key_bag</code> and <code>cert_bag</code>).</td>
  </tr>
  <tr>
    <td><code>namespace["item"]</code></td>
    <td>Attribute for setting certificate item name and key bag item name (both) to a value (<code>key_item</code> and <code>cert_item</code>).</td>
  </tr>
  <tr>
    <td><code>namespace["encrypted"]</code></td>
    <td>Attribute for setting certificate encryption and key encryption (both) to a value (<code>key_encryption</code> and <code>cert_encryption</code>).</td>
  </tr>
  <tr>
    <td><code>namespace["secret_file"]</code></td>
    <td>Attribute for setting certificate chef secret file and key chef secret file (both) to a value (<code>key_secret_file</code> and <code>cert_secret_file</code>).</td>
  </tr>
  <tr>
    <td><code>namespace["ssl_key"]["source"]</code></td>
    <td>Source type to get the SSL key from. Can be <code>"self-signed"</code>, <code>"attribute"</code>, <code>"data-bag"</code>, <code>"chef-vault"</code> or <code>"file"</code>.</td>
  </tr>
  <tr>
    <td><code>namespace["ssl_key"]["bag"]</code></td>
    <td>Name of the Data Bag where the SSL key is stored.</td>
  </tr>
  <tr>
    <td><code>namespace["ssl_key"]["item"]</code></td>
    <td>Name of the Data Bag Item where the SSL key is stored.</td>
  </tr>
  <tr>
    <td><code>namespace["ssl_key"]["item_key"]</code></td>
    <td>Key of the Data Bag Item where the SSL key is stored.</td>
  </tr>
  <tr>
    <td><code>namespace["ssl_key"]["encrypted"]</code></td>
    <td>Whether the Data Bag where the SSL key is stored is encrypted.</td>
  </tr>
  <tr>
    <td><code>namespace["ssl_key"]["secret_file"]</code></td>
    <td>Secret file used to decrypt the Data Bag where the SSL key is stored.</td>
  </tr>
  <tr>
    <td><code>namespace["ssl_key"]["content"]</code></td>
    <td>SSL key content used when reading from attributes.</td>
  </tr>
  <tr>
    <td><code>namespace["ssl_cert"]["source"]</code></td>
    <td>Source type to get the SSL cert from. Can be <code>"self-signed"</code>, <code>"attribute"</code>, <code>"data-bag"</code>, <code>"chef-vault"</code> or <code>"file"</code>.</td>
  </tr>
  <tr>
    <td><code>namespace["ssl_cert"]["bag"]</code></td>
    <td>Name of the Data Bag where the SSL cert is stored.</td>
  </tr>
  <tr>
    <td><code>namespace["ssl_cert"]["item"]</code></td>
    <td>Name of the Data Bag Item where the SSL cert is stored.</td>
  </tr>
  <tr>
    <td><code>namespace["ssl_cert"]["item_cert"]</code></td>
    <td>Cert of the Data Bag Item where the SSL cert is stored.</td>
  </tr>
  <tr>
    <td><code>namespace["ssl_cert"]["encrypted"]</code></td>
    <td>Whether the Data Bag where the SSL cert is stored is encrypted.</td>
  </tr>
  <tr>
    <td><code>namespace["ssl_cert"]["secret_file"]</code></td>
    <td>Secret file used to decrypt the Data Bag where the SSL cert is stored.</td>
  </tr>
  <tr>
    <td><code>namespace["ssl_cert"]["content"]</code></td>
    <td>SSL cert content used when reading from attributes.</td>
  </tr>
</table>

## Examples

### Apache Examples

Apache `web_app` example using community [apache2](http://community.opscode.com/cookbooks/apache2) cookbook and node attributes:

```ruby
node.default["my-webapp"]["common_name"] = "onddo.com"
node.default["my-webapp"]["ssl_cert"]["source"] = "self-signed"
node.default["my-webapp"]["ssl_key"]["source"] = "self-signed"

# we need to save the resource variable to get the key and certificate file paths
cert = ssl_certificate "my-webapp" do
  # we want to be able to use node["my-webapp"] to configure the certificate
  namespace node["my-webapp"]
  notifies :restart, "service[apache2]"
end

include_recipe "apache2"
include_recipe "apache2::mod_ssl"
web_app "my-webapp" do
  # this cookbook includes a virtualhost template for apache2
  cookbook "ssl_certificate"
  server_name cert.common_name
  docroot # [...]
  # [...]
  ssl_key cert.key_path
  ssl_cert cert.cert_path
end
```

Using custom paths:

```ruby
my_key_path = "/etc/keys/my-webapp.key"
my_cert_path = "/etc/certs/my-webapp.pem"

# there is no need to save the resource in a variable in this case because we know the paths
ssl_certificate "my-webapp" do
  key_path my_key_path
  cert_path my_cert_path
end

# Configure Apache SSL
include_recipe "apache2::mod_ssl"
web_app "my-webapp" do
  cookbook "ssl_certificate"
  # [...]
  ssl_key my_key_path
  ssl_cert my_cert_path
end
```

### Nginx Example

Minimal `nginx` example using community [nginx](http://community.opscode.com/cookbooks/nginx) cookbook:

```ruby
cert = ssl_certificate "my-webapp" do
  notifies :restart, "service[nginx]"
end

# Create virtualhost for nginx
template File.join(node["nginx"]["dir"], "sites-available", "my-webapp-ssl") do
  # You need to create a template for nginx to enable SSL support
  # and read the keys from ssl_key and ssl_cert attributes
  # [...]
  variables(
    # [...]
    :ssl_key => cert.key_path,
    :ssl_cert => cert.cert_path
  )
  notifies :reload, "service[nginx]"
end

# publish the certificate to an attribute, it may be useful
node.set["web-app"]["ssl_cert"]["content"] = cert.cert_content
```

### Reading The Certificate From Attributes

The SSL certificate can be read from an attribute directly:

```ruby
# Setting the attributes
node.default["mysite"]["ssl_key"]["content"] = "-----BEGIN PRIVATE KEY-----[...]"
node.default["mysite"]["ssl_cert"]["content"] = "-----BEGIN CERTIFICATE-----[...]"

# Creating the certificate
ssl_certificate "mysite" do
  common_name "cloud.mysite.com"
  namespace node["mysite"]
  # this will read the node["mysite"]["ssl_key"]["content"] and node["mysite"]["ssl_cert"]["content"] keys
  source "attribute"
end
```

Alternative example using a namespace and node attributes:

```ruby
# Setting the attributes
node.default["mysite"]["common_name"] = "cloud.mysite.com"
node.default["mysite"]["ssl_key"]["source"] = "attribute"
node.default["mysite"]["ssl_key"]["content"] = "-----BEGIN PRIVATE KEY-----[...]"
node.default["mysite"]["ssl_cert"]["source"] = "attribute"
node.default["mysite"]["ssl_cert"]["content"] = "-----BEGIN CERTIFICATE-----[...]"

# Creating the certificate
ssl_certificate "mysite" do
  namespace node["mysite"]
end
```

### Reading The Certificate From a Data Bag

```ruby
ssl_certificate "mysite" do
  common_name "cloud.mysite.com"
  source "data-bag"
  bag "ssl_data_bag"
  key_item "key" # data bag item
  key_item_key "content" # data bag item json key
  cert_item "cert"
  cert_item_key "content"
  encrypted true
  secret_file "/path/to/secret/file" # optional
end
```

Alternative example using a namespace and node attributes:

```ruby
# Setting the attributes
node.default["mysite"]["common_name"] = "cloud.mysite.com"

node.default["mysite"]["ssl_key"]["source"] = "data-bag"
node.default["mysite"]["ssl_key"]["bag"] = "ssl_data_bag"
node.default["mysite"]["ssl_key"]["item"] = "key"
node.default["mysite"]["ssl_key"]["item_key"] = "content"
node.default["mysite"]["ssl_key"]["encrypted"] = true
node.default["mysite"]["ssl_key"]["secret_file"] = "/path/to/secret/file"

node.default["mysite"]["ssl_cert"]["source"] = "data-bag"
node.default["mysite"]["ssl_cert"]["bag"] = "ssl_data_bag"
node.default["mysite"]["ssl_cert"]["item"] = "key"
node.default["mysite"]["ssl_cert"]["item_key"] = "content"
node.default["mysite"]["ssl_cert"]["encrypted"] = true
node.default["mysite"]["ssl_cert"]["secret_file"] = "/path/to/secret/file"

# Creating the certificate
ssl_certificate "mysite" do
  namespace node["mysite"]
end
```

### Reading The Certificate From Chef Vault

```ruby
ssl_certificate "mysite" do
  common_name "cloud.mysite.com"
  source "chef-vault"
  bag "ssl_vault_bag"
  key_item "key" # data bag item
  key_item_key "content" # data bag item json key
  cert_item "cert"
  cert_item_key "content"
end
```

The same example, using a namespace and node attributes:

```ruby
# Setting the attributes
node.default["mysite"]["common_name"] = "cloud.mysite.com"

node.default["mysite"]["ssl_key"]["source"] = "chef-vault"
node.default["mysite"]["ssl_key"]["bag"] = "ssl_vault_bag"
node.default["mysite"]["ssl_key"]["item"] = "key"
node.default["mysite"]["ssl_key"]["item_key"] = "content"

node.default["mysite"]["ssl_cert"]["source"] = "chef-vault"
node.default["mysite"]["ssl_cert"]["bag"] = "ssl_vault_bag"
node.default["mysite"]["ssl_cert"]["item"] = "key"
node.default["mysite"]["ssl_cert"]["item_key"] = "content"

# Creating the certificate
ssl_certificate "mysite" do
  namespace node["mysite"]
end
```

### Reading The Certificate From Files

```ruby
ssl_certificate "mysite" do
  common_name "cloud.mysite.com"
  source "file"
  key_path "/path/to/ssl/key"
  cert_path "/path/to/ssl/cert"
end
```

The same example, using a namespace and node attributes:

```ruby
# Setting the attributes
node.default["mysite"]["common_name"] = "cloud.mysite.com"

node.default["mysite"]["ssl_key"]["source"] = "file"
node.default["mysite"]["ssl_key"]["path"] = "/path/to/ssl/key"

node.default["mysite"]["ssl_cert"]["source"] = "file"
node.default["mysite"]["ssl_cert"]["path"] = "/path/to/ssl/cert"

# Creating the certificate
ssl_certificate "mysite" do
  namespace node["mysite"]
end
```

### Reading The Certificate From Different Places

You can also read the certificate and the private key from different places each:

```ruby
ssl_certificate "mysite" do
  common_name "cloud.mysite.com"

  # Read the private key from chef-vault
  key_source "chef-vault"
  key_bag "ssl_vault_bag"
  key_item "key" # data bag item
  key_item_key "content" # data bag item json key

  # Read the public cert from a non-encrypted data bag
  cert_source "data-bag"
  cert_bag "ssl_data_bag"
  cert_item "cert"
  cert_item_key "content"
  cert_encrypted false
end
```

The same example, using a namespace and node attributes:

```ruby
# Setting the attributes
node.default["mysite"]["common_name"] = "cloud.mysite.com"

# Read the private key from chef-vault
node.default["mysite"]["ssl_key"]["source"] = "chef-vault"
node.default["mysite"]["ssl_key"]["bag"] = "ssl_vault_bag"
node.default["mysite"]["ssl_key"]["item"] = "key"
node.default["mysite"]["ssl_key"]["item_key"] = "content"

# Read the public cert from a non-encrypted data bag
node.default["mysite"]["ssl_cert"]["source"] = "data-bag"
node.default["mysite"]["ssl_cert"]["bag"] = "ssl_data_bag"
node.default["mysite"]["ssl_cert"]["item"] = "key"
node.default["mysite"]["ssl_cert"]["item_key"] = "content"
node.default["mysite"]["ssl_cert"]["encrypted"] = false

# Creating the certificate
ssl_certificate "mysite" do
  namespace node["mysite"]
end
```

Testing
=======

## Requirements

* `vagrant`
* `berkshelf` >= `2.0`
* `test-kitchen` >= `1.2`
* `kitchen-vagrant` >= `0.10`

## Running the tests

```bash
$ kitchen test
$ kitchen verify
[...]
```

## ChefSpec matchers

### create_ssl_certificate(name)

Assert that the Chef run creates ssl_certificate.

```ruby
expect(chef_run).to create_ssl_certificate("cloud.mysite.com")
```

Contributing
============

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

See the `TODO.md` file if you're looking for inspiration.

License and Author
=====================

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Author:**          | [Raul Rodriguez](https://github.com/raulr) (<raul@onddo.com>)
| **Author:**          | [Xabier de Zuazo](https://github.com/zuazo) (<xabier@onddo.com>)
| **Copyright:**       | Copyright (c) 2014, Onddo Labs, SL. (www.onddo.com)
| **License:**         | Apache License, Version 2.0

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
        http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
