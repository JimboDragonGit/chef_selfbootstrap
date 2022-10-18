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
require_relative 'defaultworkstationresource'

module ChefWorkstationInitialize
  module SelfBootstrap
    module NoChef
      module WorkstationResourceHelpers
        include ChefWorkstationInitialize::SelfBootstrap::NoChef::WorkstationHelpers

        def default_workstation_resource
          @default_workstation_resource ||= DefaultWorkstationResource.new
        end

        def set_workstation_resource(new_resource_set)
          workstation_resource_keys.each do |key|
            workstation_resource[key.to_sym] = {}.symbolify_keys(workstation_resource[key.to_sym].respond_to?(:deep_merge) ? workstation_resource[key.to_sym].deep_merge(new_resource_set[key.to_s]) : new_resource_set[key.to_s]) unless parent_nil?(new_resource_set, key.to_s)
          end
          # if new_resource_set.respond_to?(:node) && new_resource_set.node[workstation_resource[:cookbook_source]].nil? == false
          #   workstation_resource_keys.each do |key|
          #     workstation_resource[key.to_sym] = node['infra_chef'][key.to_s]
          #   end
          # end
          workstation_resource
        end

        def swap_workstation(new_workstation)
          @workstation = new_workstation.get_workstation
        end

        def get_workstation
          # ::File.join(get_path(workstation_chef_repo_path), __FILE__.gsub(/^.*cache/), '')
          # @workstation_tool = new_workstation
          # include new_workstation
          @workstation = default_workstation_resource if @workstation.nil?
          swap_workstation(ChefWorkstationInitialize::SelfBootstrap::WithChef) if respond_to? 'Chef'
          @workstation
        end

        def workstation_resource
          get_workstation
        end

        def get_workstation_property(property_name)
          require_implement_method('get_workstation_property', %w(property_name))

          # debug_worklog("Get property #{property_name}") # if property_name == 'group'
          # property = nil
          # viarail = nil
          # if respond_to?('workstation_' + property_name)
          #   viarail = 'self workstaion'
          #   property = send('workstation_' + property_name)
          # elsif property_name != 'project_name' && respond_to?(property_name + '=')
          #   viarail = 'self'
          #   property = send(property_name)
          #   workstation_resource_property = workstation_resource[property_name.to_sym]
          #   if (property.nil? && !workstation_resource_property.nil?) || (!property.nil? && !workstation_resource_property.nil?)
          #     viarail += ' Using workstation_resource_property'
          #     property = set_workstation_property(property_name, workstation_resource_property) if property != workstation_resource_property
          #   elsif !property.nil? && workstation_resource_property.nil?
          #     viarail += ' Using property'
          #     property = set_workstation_property(property_name, property)
          #   elsif property.nil? && workstation_resource_property.nil?
          #     viarail += ' No property present'
          #     worklog("Property #{property_name} is not present")
          #   end
          # elsif !respond_to?('new_resource') || new_resource.nil?
          #   viarail = 'workstation_resource'
          #   property = workstation_resource[property_name.to_sym]
          # elsif new_resource.respond_to?(property_name)
          #   viarail = 'new_resource'
          #   property = new_resource.send(property_name)
          # elsif new_resource.is_a?(Hash)
          #   viarail = 'new_resource(Hash)'
          #   property = new_resource[property_name.to_sym]
          # else
          #   viarail = 'UNKNOWN'
          #   worklog("new_resource doesn't respond to #{property_name} :: #{new_resource.class} :: #{new_resource.methods}")
          #   property = nil
          # end
          # debug_worklog("property #{property_name} is #{property.is_a?(::Dir) ? get_path(property) : property} via #{viarail}") # if property_name == 'group'
          # property
        end

        def set_workstation_property(property_name, value)
          require_implement_method('set_workstation_property', %w(property_name value))

          # debug_worklog("Assign property #{property_name} is value #{value.is_a?(::Dir) ? get_path(value) : value}")
          # assign = false
          # if property_name != 'project_name' && respond_to?(property_name + '=')
          #   assign = true
          #   send(property_name + '=', value)
          # end
          # if !respond_to?('new_resource') || new_resource.nil?
          #   assign = true
          #   workstation_resource[property_name.to_sym] = value
          # end
          # if respond_to?('new_resource') && new_resource.respond_to?(property_name)
          #   assign = true
          #   new_resource.send(property_name, value)
          # end
          # if respond_to?('new_resource') && new_resource.is_a?(Hash)
          #   assign = true
          #   new_resource[property_name] = value
          # end
          # worklog("new_resource could not assign value '#{value}' not respond to #{property_name} :: #{new_resource.class} :: #{new_resource.methods}") unless assign
          # get_workstation_property(property_name)
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
