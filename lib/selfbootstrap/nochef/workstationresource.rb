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

        def set_workstation_data(workstation_data)
          # ::File.join(get_path(workstation_chef_repo_path), __FILE__.gsub(/^.*cache/), '')
          # @workstation_tool = new_workstation
          # include new_workstation
          # @workstation = default_workstation_resource if @workstation.nil?
          # swap_workstation(ChefWorkstationInitialize::SelfBootstrap::WithChef) if respond_to? 'Chef'
          # @workstation

          workstation_data.send(:extend, ChefWorkstationInitialize::SelfBootstrap)
          workstation_data
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
