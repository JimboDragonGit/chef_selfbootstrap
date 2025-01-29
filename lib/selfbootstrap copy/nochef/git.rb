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

require_relative 'ssh'

module ChefWorkstationInitialize
  module SelfBootstrap
    module NoChef
      module GitHelpers
        include ChefWorkstationInitialize::SelfBootstrap::NoChef::SSHHelpers

        def get_git_submodule(git_name, git_info, action, compile_time)
          require_implement_method('get_git_submodule', %w(git_name git_info action compile_time))
        end

        def get_git_server(git_action)
          require_implement_method('get_git_server', %w(git_action))
        end

        def git_exec(*args, **run_opts)
          base_command('git', args, run_opts)
        end

        def git_submodule_init
          git_exec('submodule' + 'init')
          git_exec('submodule' + 'update')
        end

        def repository_list
          if parent_nil?(workstation_resource, 'gitinfo', 'submodules')
            worklog('Use default repository')
            [project_name, "#{project_name}_generator", new_cookbook_name]
          else
            worklog("workstation_resource[:gitinfo][\"submodules\"] = #{JSON.pretty_generate(workstation_resource[:gitinfo]['submodules'])}")
            [project_name, "#{project_name}_generator", new_cookbook_name] + workstation_resource[:gitinfo]['submodules'].keys
          end
        end

        def all_cookbooks
          cookbooks_Arr = []
          workstation_resource[:gitinfo]['submodules'].each do |gitname, git_info|
            case git_info['type']
            when 'cookbooks', 'libraries', 'resources'
              cookbooks_Arr.push(gitname)
            end
          end unless parent_nil?(workstation_resource[:gitinfo], 'submodules')
          cookbooks_Arr
        end

        def get_git_relative_path(gitname)
          if gitname == project_name
            ''
          elsif workstation_resource[:gitinfo]['submodules'][gitname].nil?
            ''
          else
            ::File.join(workstation_resource[:gitinfo]['submodules'][gitname]['type'], gitname)
          end
        end

        def get_git_path(gitname)
          ::File.join(get_path(workstation_chef_repo_path), get_git_relative_path(gitname))
        end

        def get_self_git(action, compile_time)
          get_git_submodule(project_name, workstation_resource[:gitinfo], action, compile_time)
        end

        def generate_json_repo(type, repository, revision = 'master', remote = 'origin', submodule_list = nil, additional_remotes = nil)
          json_output = {
            type: type,
            repository: repository,
            revision: revision,
            remote: remote,
            submodules: submodule_list,
            additional_remotes: additional_remotes,
          }
          worklog("Generate json for #{JSON.pretty_generate(json_output)}")
          json_output
        end

        def generate_git_submodules(modules)
          json_submodules = {}
          modules.each do |module_name, module_info|
            json_submodules[module_name] = { path: get_git_path(module_name), repository: module_info['repository'] }
          end
          json_submodules
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
