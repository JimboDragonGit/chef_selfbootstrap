#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

require_relative 'verifiers'
require_relative 'platforms'

module ChefWorkstationInitialize
  module SelfBootstrap
    module NoChef
      module ProvisionersHelpers
        include ChefWorkstationInitialize::SelfBootstrap::NoChef::VerifiersHelpers
        include ChefWorkstationInitialize::SelfBootstrap::NoChef::PlatformsHelpers
        #
        # Define the methods that you would like to assist the work you do in recipes,
        # resources, or templates.
        #
        # def my_helper_method
        #   worklog('Running method my_helper_method' + " for class #{self.class} inside file #{__FILE__}")

        #   # help method implementation
        # end

        def provisioners
          worklog('Running method provisioners' + " for class #{self.class} inside file #{__FILE__}")

          [chef_zero_provisioner]
        end

        def chef_zero_provisioner
          worklog('Running method chef_zero_provisioner' + " for class #{self.class} inside file #{__FILE__}")

          {
            name: 'chef_zero',
            always_update_cookbooks: true,
            kitchen_root: kitchen_root,
            # encrypted_data_bag_secret_key_path:,
          }
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
#     extend ChefWorkstationInitialize::ProvisionersHelpers
#
#     my_helper_method
#
# You may also add this to a single resource within a recipe:
#
#     template '/etc/app.conf' do
#       extend ChefWorkstationInitialize::ProvisionersHelpers
#       variables specific_key: my_helper_method
#     end
#
