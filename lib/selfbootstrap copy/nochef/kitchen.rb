# name 'Helper file for chef_workstation_initialize'
# maintainer 'Jimbo Dragon'
# maintainer_email 'jimbo_dragon@hotmail.com'
# license 'MIT'
# description 'Helper file for chef_workstation_initialize'
# version '0.1.0'
# chef_version '>= 16.6.14'
# issues_url 'https://github.com/jimbodragon/chef_workstation_initialize/issues'
# source_url 'https://github.com/jimbodragon/chef_workstation_initialize'
#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

require_relative 'chef'
require_relative 'provisioners'

module ChefWorkstationInitialize
  module SelfBootstrap
    module NoChef
      module KitchenHelpers
        include ChefWorkstationInitialize::SelfBootstrap::NoChef::ChefHelpers
        include ChefWorkstationInitialize::SelfBootstrap::NoChef::ProvisionersHelpers

        def is_kitchen_command?
          ::File.basename($PROGRAM_NAME).eql?('kitchen')
        end

        def kitchen(*args, **run_opts)
          write_kitchen_file unless args.eql? ['init']
          base_command('kitchen', args, run_opts)
        end

        def kitchen_root
          get_path(workstation_chef_repo_path)
        end

        def generate_kitchen(machine_name)
          kitchen_machine(machine_name, workstation_resource[:user], workstation_resource[:group], workstation_chef_repo_path)
        end

        def generate_machine(machine_name)
          kitchen_machine(machine_name, workstation_resource[:user], workstation_resource[:group], workstation_chef_repo_path)
        end

        def building_kitchen
          worklog 'kitchen converge'
          kitchen 'converge', cwd: workstation_chef_repo_path
        end

        def kitchen_machine(machine_name, kitchen_user, kitchen_group, kitchen_dir)
          change_unix_permission

          worklog "kitchen converge #{machine_name}"
          kitchen "converge #{machine_name}"

          change_unix_permission
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
#     extend ChefWorkstationInitialize::ChefHelpers
#
#     my_helper_method
#
# You may also add this to a single resource within a recipe:
#
#     template '/etc/app.conf' do
#       extend ChefWorkstationInitialize::ChefHelpers
#       variables specific_key: my_helper_method
#     end
#

# require_relative "../providers/git_resource"
  