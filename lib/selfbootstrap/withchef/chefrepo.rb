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

module ChefWorkstationInitialize
  module SelfBootstrap
    module WithChef
      module ChefRepoHelpers
        include ChefWorkstationInitialize::SelfBootstrap::WithChef::ChefHelpers

        def define_cron_job
          cron_d "chef_client_#{project_name}" do
            if workstation_resource[:chef_boostrapped]
              command               'chef-client'
            else
              command               workstation_resource[:cron_chef_solo_command]
            end
            comment               'Run chef client periodicaly'
            day                   workstation_resource[:cron]['day'] if workstation_resource[:cron]['day']
            hour                  workstation_resource[:cron]['hour'] if workstation_resource[:cron]['hour']
            minute                workstation_resource[:cron]['minute'] if workstation_resource[:cron]['minute']
            month                 workstation_resource[:cron]['month'] if workstation_resource[:cron]['month']
            weekday               workstation_resource[:cron]['weekday'] if workstation_resource[:cron]['weekday']
          end
        end

        def render_template(generated_path, source, **variables)
          template generated_path do
            extend ChefWorkstationInitialize::SelfBootstrap
            cookbook workstation_resource[:cookbook_source]
            source source
            variables variables
          end
          template ::File.join(get_path(workstation_chef_repo_path), 'chefignore') do
            extend ChefWorkstationInitialize::SelfBootstrap
            cookbook workstation_resource[:cookbook_source]
            source 'chefignore.erb'
            variables(workstation: self)
            action :create_if_missing
          end
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
  