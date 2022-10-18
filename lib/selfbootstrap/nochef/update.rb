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

require_relative 'knife'

module ChefWorkstationInitialize
  module SelfBootstrap
    module NoChef
      module UpdateHelpers
        include ChefWorkstationInitialize::SelfBootstrap::NoChef::KnifeHelpers

        def commit_state
          worklog('Running method commit_state(auto_chef_repo)' + " for class #{self.class} inside file #{__FILE__}")

          repository_list.each do |submodule|
            %w(commit push).each do |action|
              get_git_submodule(submodule, gitinfo['submodules'][submodule], action.to_sym, workstation_resource[:compile_time])
            end unless parent_nil?(gitinfo, 'submodules', submodule)
          end
          get_self_git :commit, workstation_resource[:compile_time]
          get_self_git :push, workstation_resource[:compile_time]
          Chef::Log.warn('TODO manage branch and merge for the workflow')
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
#     extend ChefWorkstationInitialize::UpdateHelpers
#
#     my_helper_method
#
# You may also add this to a single resource within a recipe:
#
#     template '/etc/app.conf' do
#       extend ChefWorkstationInitialize::UpdateHelpers
#       variables specific_key: my_helper_method
#     end
#
