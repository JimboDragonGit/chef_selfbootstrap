#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

require_relative '../nochef'
require_relative '../withchef'

module ChefWorkstationInitialize
  module SelfBootstrap
    module WithMixLib
      module DefaultMethodsHelpers
        # include ChefWorkstationInitialize::SelfBootstrap::NoChef

        def method_missing(method_name, *args, &block)
          caller_worklog
          if is_with_chef?
            prepend ChefWorkstationInitialize::SelfBootstrap::WithChef
            method_missing(method_name, *args, &block)
          else
            super
          end
        end
      end
    end
  end
end