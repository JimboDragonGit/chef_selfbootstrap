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

require_relative 'berks'

module ChefWorkstationInitialize
  module SelfBootstrap
    module NoChef
      module ChefHelpers
        include ChefWorkstationInitialize::SelfBootstrap::NoChef::BerksHelpers

        def is_chef_enabled?
          const_defined? :Chef
        end

        def is_chef_command?
          ::File.basename($PROGRAM_NAME).eql?('chef')
        end

        def is_chef_cli_command?
          ::File.basename($PROGRAM_NAME).eql?('chef-cli')
        end

        def is_chef_client_command?
          ::File.basename($PROGRAM_NAME).eql?('chef-client')
        end

        def is_chef_installed?
          ::Dir.exist?('/opt/chef-workstation')
        end

        def is_chef_profile_set?
          if is_chef_installed?
            ruby_path = find_program('ruby')
            chef_profile_set = ruby_path.include?('/opt/chef-workstation')
            worklog("ruby_path = #{ruby_path}(#{chef_profile_set})")
            chef_profile_set
          else
            false
          end
        end

        def is_chefworkstation_available?
          # caller_worklog
          # chefworkstation_available = false
          # $LOAD_PATH.each do |loaded_path|
          #   worklog "loaded_path = #{loaded_path}"
          #   if loaded_path.include?('/opt/chef-workstation')
          #     chefworkstation_available = true
          #     return true
          #   end
          # end
          # worklog "tabarnak de calisse \n chefworkstation_available = #{chefworkstation_available}"
          # chefworkstation_available
          Gem.ruby.include?('/opt/chef-workstation')
          # output = chef '-v', as_data: true
          # return false if output.empty?
          # output.include? 'Chef Workstation'
        end

        def chef(*args, **run_opts)
          chef_cmd = 'chef'
          base_command(chef_cmd, args, run_opts)
        end

        def chef_client(*args, **run_opts)
          base_command('chef-client', args, run_opts)
        end

        def is_knife_gem_install?
          chef('gem list -i knife') == 'true'
        end

        def install_chef_workstation
          base_command('curl -L https://omnitruck.chef.io/install.sh | bash -s -- -s once -P chef-workstation', [], as_system: true)
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
