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

        def is_chefworkstation_available?
          Gem.ruby.include?('/opt/chef-workstation')
        end

        def chef_client(*args, **run_opts)
          base_command('chef-client', args, run_opts)
        end

        def chef(*args, **run_opts)
          chef_cmd = 'chef'
          base_command(chef_cmd, args, run_opts)
        end

        def chef_client_self_bootstrap_cmd
          debug_worklog 'boostrapped with solo and chef-client'

          # generate_workstation_berksfile
          generate_policy 'infra_chef'
          render_template(::File.join(get_path(workstation_solo_d_dir), ::File.join(project_name, project_name + '.rb')), 'solo.rb.erb', workstation: self)
          chef_client_options = [self_bootstrap_options]
          # chef_client_options << '--runlist infra_chef'
          chef_client_options << '--named-run-list ' + 'infra_chef'
          if ::File.exist?('solo.rb')
            chef_client_options << '-c solo.rb'
          else
            chef_solo_options_command.each do |option|
              chef_client_options << option
            end
            # chef_client_options << "--chef-zero-host #{default_hostname}"
            # chef_client_options << "--chef-zero-port #{default_chefzero_portrange}"
          end
          debug_worklog "chef_client_options #{chef_client_options.join("\n")}"
          chef_client chef_client_options, live: true, as_system: true
        end
      end
    end
  end
end
