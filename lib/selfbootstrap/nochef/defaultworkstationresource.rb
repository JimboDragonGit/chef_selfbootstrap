#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

module ChefWorkstationInitialize
  module SelfBootstrap
    module NoChef
      module WorkstationResourceHelpers
        def workstation_resource_keys
          default_workstation_data.keys
        end

        def default_workstation_data
          {
            install_dir: ::Dir.getwd,
            project_name: ::File.basename(::Dir.getwd),
            cookbook_source: 'infra_chef',
            project_description: nil,
            environments: nil,
            initial_command: nil,
            cron_chef_solo_command: nil,
            chef_boostrapped: nil,
            environment: nil,
            user: ENV['USER'],
            group: ENV['GROUP'].nil? ? ENV['USER'] : ENV['GROUP'],
            home: ENV['HOME'],
            run_for_type: nil,
            gitinfo: nil,
            cron: nil,
            provisioners: nil,
            verifiers: nil,
            platforms: nil,
            suites: nil,
            default_attributes: nil,
            override_attributes: nil,
            solo: true,
            data_bag_encrypt_version: 3,
            file_cache_path: '',
            debug: false,
          }
        end

        class DefaultWorkstationResource
          include ChefWorkstationInitialize::SelfBootstrap::NoChef
          prepend ChefWorkstationInitialize::SelfBootstrap::NoChef

          def initialize
            config_loader = ChefConfig::WorkstationConfigLoader.new(nil)
            Chef::Config.from_file(config_loader.config_location)
          end

          def workstation_resource_keys
            @selfbootstrap_resource.keys
          end

          def [](key)
            @selfbootstrap_resource ||= default_workstation_data
            if @selfbootstrap_resource.key?(key.to_sym)
              @selfbootstrap_resource[key.to_sym]
            elsif @selfbootstrap_resource.key?(key.to_s)
              @selfbootstrap_resource[key.to_s]
            end
          end

          def get_workstation_property(property_name)
            debug_worklog("Get property #{property_name}") # if property_name == 'group'
            self[property_name]
          end

          def set_workstation_property(property_name, value)
            debug_worklog("Assign property #{property_name} is value #{value.is_a?(::Dir) ? get_path(value) : value}")
            self[property_name] = value
          end

          def render_template(generated_path, source, **variables)
            if ::File.basename(generated_path).eq?('kitchen.yml')
              worklog('Generating a new kitchen file')
              kitchen 'init'
            else
              super(generated_path, source, variables)
            end
          end
        end
      end
    end
    #
    # Define the methods that you would like to assist the work you do in recipes,
    # resources, or templates.
    #
    # def my_helper_method
    #   # help method implementation
    # end
  end
end

#
# The module you have defined may be extended within the recipe to grant the
# recipe the helper methods you define.
#
# Within your recipe you would write:
#
#     extend ChefWorkstationInitialize::SelfbootstrapNochefDefaultworkstationresourceHelpers
#
#     my_helper_method
#
# You may also add this to a single resource within a recipe:
#
#     template '/etc/app.conf' do
#       extend ChefWorkstationInitialize::SelfbootstrapNochefDefaultworkstationresourceHelpers
#       variables specific_key: my_helper_method
#     end
#
