
module Chef::SSL
  module RecipeHelpers

    def generate_certificate(namespace, common_name = nil)
      namespace = [ namespace ].flatten
      attributes = namespace.inject(node) { |n, k| n[k] }

      cert = Chef::SSL::Certificate.new({
        :name => namespace.join('-'),
        :common_name => common_name || attributes['common_name'],
        :ssl_key => attributes['ssl_key'],
        :ssl_cert => attributes['ssl_cert'],
        :platform => node['platform'],
      })

      # install needed dependencies
      chef_gem 'chef-vault' if cert.depends_chef_vault?

      # Create ssl certificate key
      file "#{namespace}.key" do
        path cert.key_path
        owner 'root'
        group 'root'
        mode 00600
        content cert.key_content
        action :create
      end

      # Create ssl certificate
      file "#{namespace}.pem" do
        path cert.cert_path
        owner 'root'
        group 'root'
        mode 00644
        content cert.cert_content
        action :create
      end

      cert
    end

  end
end
