#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

require_relative '../withmixlib'
require_relative 'workstation'
# require_relative 'defaultworkstationresource'

module ChefWorkstationInitialize
  module SelfBootstrap
    module NoChef
      module WorkstationResourceHelpers
        include ChefWorkstationInitialize::SelfBootstrap::NoChef::WorkstationHelpers

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
            # environment_variables: ENV,
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

        def get_configuration_data
          bootstrap_self_command
        end

        def workstation_resource
          default_workstation_data
        end
      end
    end
  end
end

  #
  # The module you have defined may be extended within the recipe to grant the
  # recipe the helper methods you define.
  #
  # Within your recipe you would write:
  #
  #     extend ChefWorkstationInitialize::WorkstationHelpers
  #
  #     my_helper_method
  #
  # You may also add this to a single resource within a recipe:
  #
  #     template '/etc/app.conf' do
  #       extend ChefWorkstationInitialize::WorkstationHelpers
  #       variables specific_key: my_helper_method
  #     end
  #
