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

require_relative 'chefrepo'

module ChefWorkstationInitialize
  module SelfBootstrap
    module NoChef
      module KnifeHelpers
        include ChefWorkstationInitialize::SelfBootstrap::NoChef::ChefRepoHelpers

        def knife(*args, **run_opts)
          base_command('knife', *args, **run_opts)
        end

        def get_solo_cmd
          worklog 'Get solo from knife'
          knife 'config show solo --format json', live: true
        end

        def knife_search_self_cmd
          knife_options = ['search']
          knife_options << 'node'
          knife_options << "name:#{default_hostname}"
          knife_options << '--format json'
          knife_options << '-z' if is_solo?
          knife knife_options
        end

        def self_bootstrap_options
          "-N #{default_hostname}"
        end

        def knife_get_node_attribute(nodename, attribute)
          knife "node show #{nodename} -a #{attribute}"
        end

        def knife_self_bootstrap_cmd
          knife "bootstrap #{self_bootstrap_options} --policy-group #{project_name} --policy-name #{project_name} #{default_hostname}"
        end

        def chef_client_self_bootstrap_cmd
          chef_client_options = [self_bootstrap_options]
          chef_client_options << "--runlist #{project_name}"
          if ::File.exist?('solo.rb')
            chef_client_options << '-c solo.rb'
          else
            chef_client_options << chef_solo_options_command
            chef_client_options << "--chef-zero-host #{default_hostname}"
            chef_client_options << "--chef-zero-port #{default_chefzero_portrange}"
          end
          chef_client chef_client_options, debug: true
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
  