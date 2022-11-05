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

require_relative 'git'

module ChefWorkstationInitialize
  module SelfBootstrap
    module NoChef
      module BerksHelpers
        include ChefWorkstationInitialize::SelfBootstrap::NoChef::GitHelpers

        def berks(*args, **run_opts)
          base_command('berks', *args, **run_opts)
        end

        def berks_vendor_init
          worklog "Berks vendor initial cookbook\n"
          berks 'install'
          berks 'vendor'
        end

        def delete_cookbook_berkslock(cookbookname)
          if dir_exist(get_git_path(cookbookname))
            cookbookdir = ::Dir.new(get_git_path(cookbookname))
            berkslock = ::File.join(cookbookdir, 'Berksfile.lock')
            ::File.delete(berkslock) if cookbookdir.include?('Berksfile.lock')
          end
        end

        def delete_all_berkslock
          all_cookbooks.each do |cookbookname|
            delete_cookbook_berkslock(cookbookname)
          end
        end

        def berks_vendor_all_cookbook
          all_cookbooks.each do |cookbook|
            berks_vendor_cookbook(cookbook)
          end
        end

        def berks_vendor_cookbook(name)
          berks_vendor(name, project_name, workstation_berks_vendor_dir, get_git_path(name))
        end

        def berks_vendor(cookbookname, project_name, berks_path, cookbook_path)
          if dir_exist(cookbook_path)
            worklog "Adding berks vendor of the cookbook #{cookbookname} into the chef repo #{project_name}"
            berks("vendor #{berks_path}", cwd: cookbook_path) if file_exist?(::File.join(cookbook_path, 'Berksfile'))
          end
        end

        def self_berks_vendor
          berks_vendor_cookbook(new_cookbook_name)
        end

        def reset_berks_vendor_dir
          FileUtils.rm_rf(workstation_berks_vendor_dir)
          generate_directory workstation_berks_vendor_dir
        end

        # def remove_double_cookbooks
        #   all_cookbooks.each do |cookbookname|
        #     ::FileUtils.rm_rf(::File.join(get_path(workstation_berks_vendor_dir), cookbookname)) if ::Dir.new(workstation_berks_vendor_dir).include?(cookbookname)
        #   end
        # end
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
  