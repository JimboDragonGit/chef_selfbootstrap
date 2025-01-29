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

require_relative 'commandline'

module ChefWorkstationInitialize
  module SelfBootstrap
    module WithChef
      module GitHelpers
        include ChefWorkstationInitialize::SelfBootstrap::WithChef::CommandlineHelpers

        def get_git_submodule(git_name, git_info, action, compile_time)
          # logger.warn("get_git_submodule of #{git_name} ==>\n#{git_info}")
          worklog("get_git_submodule of #{git_name} ==>\n#{git_info}")
          unless git_info.nil? || git_info['repository'].nil? || git_info['remote'].nil?
            git_submodule git_name do
              message "Get git_submodule #{git_name} for action #{action} at compile time #{compile_time} on remote '#{git_info['remote']}', repository #{git_info['repository']}, revision '#{git_info['revision']}', type '#{git_info['type']}', git_info '#{JSON.pretty_generate(git_info)}'"
              # build_method build_method
              destination (git_info['type'] == 'main_repo' || git_info['type'] == '' || git_info['type'].nil?) ? workstation_chef_repo_path : get_git_path(git_name)
              repository git_info['repository']
              revision git_info['revision']
              remote git_info['remote']
              checkout_branch "#{project_name}_#{workstation_resource[:environment]}"
              additional_remotes git_info['additional_remotes'] if git_info['additional_remotes']
              if git_info['submodules']
                submodules generate_git_submodules(git_info['submodules'])
                enable_submodules true
              end
              action action
              compile_time compile_time
            end ## end git
          end
        end

        def get_git_server(git_action)
          git_server project_name do
            repositories repository_list
            userdatabag 'users'
            secretdatabag cookbook_name
            secretdatabagitem 'cookbook_secret_keys'
            secretdatabagkey 'secret'
            userdatabagkey 'decompose_public_key'
            action git_action
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
