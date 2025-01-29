#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

require_relative 'chefsolo'

module SelfBootstrap
  module ChefClient
    include SelfBootstrap::ChefSolo

    def load_chef
      super
      unless is_solo?
        require 'chef/application/client'

        @clientapp = Chef::Application::Client.new
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
#     extend SelfBootstrap::NoChefHelpers
#
#     my_helper_method
#
# You may also add this to a single resource within a recipe:
#
#     template '/etc/app.conf' do
#       extend SelfBootstrap::NoChefHelpers
#       variables specific_key: my_helper_method
#     end
#
