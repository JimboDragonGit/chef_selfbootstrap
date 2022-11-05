#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

require_relative 'users'

module ChefWorkstationInitialize
  module SelfBootstrap
    module NoChef
      module WorkstationHelpers
        include ChefWorkstationInitialize::SelfBootstrap::NoChef::UsersHelpers

        def authenticate_to_chef_infra_server
          chef_client '--local-mode'
        end

        def rebuild_the_node
          chef_client_self_bootstrap_cmd
        end

        def bootstrap_order
          loadchef
          get_configuration_data
          authenticate_to_chef_infra_server
          rebuild_the_node
          expand_run_list
          synchronize_cookbooks
          reset_node_attributes
          compile_resource_collection
          converge_nodes
          update_node
          get_reports
          check_compliance
          wait_until_next_run
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
