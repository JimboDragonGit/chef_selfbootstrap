#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

require_relative 'commands'

module SelfBootstrap
  module ReloadCommand
    include SelfBootstrap::Commands

    def restart_bootstrap
      rerun_opt = { as_exit: true, live: true }
      debug_worklog 'Restart bootstrap to reload config'
      caller_worklog if rerun_opt[:debug]
      if run_as_root?
        install_chef_workstation
        set_chef_profile
      else
        debug_worklog 'Self bootstrap with sudo command'
        rerun_opt[:sudo] = true
      end
      restart_command = "/opt/chef-workstation/embedded/bin/ruby #{SelfBootstrap.get_start_program}"
      install_this_gem
      create_chef_additionnal_dir
      debug_worklog 'boostrapped with solo and kitchen and root'
      base_command(restart_command, ARGV, rerun_opt)
      worklog "\n\nNEVER SUPPOSSED TO SEE THAT!!!!!\n\n"
    end
  end
end

#
# The module you have defined may be extended within the recipe to grant the
# recipe the helper methods you define.
#
# Within your recipe you would write:
#
#     extend SelfBootstrap::NoChefHelpers
#
#     my_helper_method
#
# You may also add this to a single resource within a recipe:
#
#     template '/etc/app.conf' do
#       extend SelfBootstrap::NoChefHelpers
#       variables specific_key: my_helper_method
#     end
#
