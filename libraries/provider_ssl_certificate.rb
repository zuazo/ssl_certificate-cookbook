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
          r = Chef::Resource::File.new(
            "#{main_resource.name} SSL certificate key",
            @new_resource.run_context
          )
          r.path(main_resource.key_path)
          r.owner('root')
          r.group('root')
          r.mode(00600)
          r.content(main_resource.key_content)
          r.run_action(:create)
          updated_by_last_action ||= r.updated_by_last_action?

          # Create ssl certificate
          r = Chef::Resource::File.new(
            "#{main_resource.name} SSL public certificate",
            @new_resource.run_context
          )
          r.path(main_resource.cert_path)
          r.owner('root')
          r.group('root')
          r.mode(00644)
          r.content(main_resource.cert_content)
          r.run_action(:create)
          updated_by_last_action ||= r.updated_by_last_action?

          # Conditionally write intermediary chain certificate
          if not main_resource.chain_content.nil? and not main_resource.chain_name.nil?
            r = Chef::Resource::File.new(
              "#{main_resource.name} SSL intermediary chain certificate",
              @new_resource.run_context
            )
            r.path(main_resource.chain_path)
            r.owner('root')
            r.group('root')
            r.mode(00644)
            r.content(main_resource.chain_content)
            r.run_action(:create)
            updated_by_last_action ||= r.updated_by_last_action?
          end

        end

        main_resource.updated_by_last_action(updated_by_last_action)
      end

    end
  end
end
