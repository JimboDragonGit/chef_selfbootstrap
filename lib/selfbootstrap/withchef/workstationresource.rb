#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

require_relative 'workstation'

module ChefWorkstationInitialize
  module SelfBootstrap
    module WithChef
      module WorkstationResourceHelpers
        include ChefWorkstationInitialize::SelfBootstrap::WithChef::WorkstationHelpers

        # class ChefConfigResource < ChefWorkstationInitialize::SelfBootstrap::NoChef::WorkstationResourceHelpers::DefaultWorkstationResource
        #   include ChefWorkstationInitialize::SelfBootstrap::WithChef

        #   def [](key)
        #     debug_worklog('Searching config key" ' + key.to_s + '"') unless key.to_s == 'debug'
        #     if default_workstation_resource.key?(key)
        #       default_workstation_resource[key]
        #     elsif default_workstation_resource.key?(key.to_s)
        #       default_workstation_resource[key.to_s]
        #     end
        #   end
        # end

        # def get_workstation
        #   debug_worklog "Get workstation from #{self.class}"
        #   @workstation = ChefConfigResource.new if @workstation.nil?
        #   swap_workstation(ChefWorkstationInitialize::SelfBootstrap::WithLogger) if respond_to? 'logger'
        #   @workstation
        # end

        def workstation_resource
          @workstation_data ||= (
            if Chef::Config[:selfbootstrap].nil?
              config_loader = ChefConfig::WorkstationConfigLoader.new(nil)
              Chef::Config.from_file(config_loader.config_location) unless config_loader.config_location.nil?
              default_workstation_data.deep_merge Chef::Config[:selfbootstrap]
            end
          )
          @workstation_data
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
