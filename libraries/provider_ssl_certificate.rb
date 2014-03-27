require 'chef/provider'

class Chef
  class Provider
    class SslCertificate < Chef::Provider

      def load_current_resource
        @current_resource ||= Chef::Resource::SslCertificate.new(@new_resource.name, run_context)
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

        unless @current_resource.exists? and @current_resource == @new_resource and
          main_resource.updated_by_last_action? == false

          # Create ssl certificate key
          r = file "#{main_resource.name} SSL certificate key" do
            path main_resource.key_path
            owner 'root'
            group 'root'
            mode 00600
            content main_resource.key_content
            action :create
          end
          updated_by_last_action ||= r.updated_by_last_action?

          # Create ssl certificate
          r = file "#{main_resource.name} SSL public certificate" do
            path main_resource.cert_path
            owner 'root'
            group 'root'
            mode 00644
            content main_resource.cert_content
            action :create
          end
          updated_by_last_action ||= r.updated_by_last_action?

        end

        main_resource.updated_by_last_action(updated_by_last_action)
      end

    end
  end
end
