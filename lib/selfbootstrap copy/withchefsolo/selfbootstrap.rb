#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

require_relative 'workstationresource'

module ChefWorkstationInitialize
  module SelfBootstrap
    module WithChef
      module SelfBootstrapHelpers
        include ChefWorkstationInitialize::SelfBootstrap::WithChef::WorkstationResourceHelpers

        def load_chef
          if is_with_logger?
            extend ChefWorkstationInitialize::SelfBootstrap::WithLogger
            load_chef
          end
        end

        def bootstrap_self_command
          if is_solo?
            chef_client_self_bootstrap_cmd
          else
            knife_self_bootstrap_cmd
          end
          debug_worklog 'bootstrap self command completed WithMixLib'
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

