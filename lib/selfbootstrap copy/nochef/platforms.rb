#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

require_relative 'suites'

module ChefWorkstationInitialize
  module SelfBootstrap
    module NoChef
      module PlatformsHelpers
        include ChefWorkstationInitialize::SelfBootstrap::NoChef::SuitesHelpers
        #
        # Define the methods that you would like to assist the work you do in recipes,
        # resources, or templates.
        #
        # def my_helper_method
        #   worklog('Running method my_helper_method' + " for class #{self.class} inside file #{__FILE__}")

        #   # help method implementation
        # end
        def default_platforms
          worklog('Running method default_platforms' + " for class #{self.class} inside file #{__FILE__}")

          workstation_resource[:platforms]
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
#     extend ChefWorkstationInitialize::PlatformsHelpers
#
#     my_helper_method
#
# You may also add this to a single resource within a recipe:
#
#     template '/etc/app.conf' do
#       extend ChefWorkstationInitialize::PlatformsHelpers
#       variables specific_key: my_helper_method
#     end
#
