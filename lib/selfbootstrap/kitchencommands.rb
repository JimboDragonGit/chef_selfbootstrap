#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

require_relative 'chefcommands'

module SelfBootstrap
  module KitchenCommands
    include SelfBootstrap::ChefCommands

    def is_kitchen_command?
      ::File.basename($PROGRAM_NAME).eql?('kitchen')
    end

    def kitchen(*args, **run_opts)
      write_kitchen_file unless args.eql? ['init']
      base_command('kitchen', args, run_opts)
    end
  end
end

#
# The module you have defined may be extended within the recipe to grant the
# recipe the helper methods you define.
#
# Within your recipe you would write:
#
#     extend SelfBootstrap::WithChefHelpers
#
#     my_helper_method
#
# You may also add this to a single resource within a recipe:
#
#     template '/etc/app.conf' do
#       extend SelfBootstrap::WithChefHelpers
#       variables specific_key: my_helper_method
#     end
#
