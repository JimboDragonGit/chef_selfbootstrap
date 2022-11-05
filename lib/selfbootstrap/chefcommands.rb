#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

require_relative 'reloadcommand'

module SelfBootstrap
  module ChefCommands
    include SelfBootstrap::ReloadCommand

    def chef_client(args = [], run_opts = {})
      base_command('chef-client', args, run_opts)
    end

    def chef(args = [], run_opts = {})
      chef_cmd = 'chef'
      config_file = ::File.join(workstation_solo_d_dir, project_name + '.rb')
      args << ' -c ' + config_file if ::File.exist?(config_file) && args[0] != 'gem'
      base_command(chef_cmd, args, run_opts)
    end

    def chef_gem_exec(args = [], run_opts = {})
      chef((['gem'] | args).compact, run_opts)
    end

    def install_this_gem
      chef_gem_exec %w(install selfbootstrap), as_system: true
    end

    def get_chef_shell(variable_name)
      chef_shell = chef %w(shell-init bash), as_data: true, no_run_option: true
      variable_values = chef_shell.lines.each_with_object([]) do |value, container|
        container << value.split('=')[1] if value.include? variable_name
        container
      end
      debug_worklog "variable_values for #{variable_name} = #{JSON.parse variable_values[0]}"
      JSON.parse(variable_values[0])
    end
  end
end

#
# The module you have defined may be extended within the recipe to grant the
# recipe the helper methods you define.
#
# Within your recipe you would write:
#
#     extend SelfBootstrap::WithChefHelpers
#
#     my_helper_method
#
# You may also add this to a single resource within a recipe:
#
#     template '/etc/app.conf' do
#       extend SelfBootstrap::WithChefHelpers
#       variables specific_key: my_helper_method
#     end
#
