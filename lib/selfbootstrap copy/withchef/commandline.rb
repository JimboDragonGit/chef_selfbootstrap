#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

require_relative 'defaultmethods'

module ChefWorkstationInitialize
  module SelfBootstrap
    module WithChef
      module CommandlineHelpers
        include ChefWorkstationInitialize::SelfBootstrap::WithChef::DefaultMethodsHelpers

        # def run_options(run_opts = {})
        #   # debug_worklog run_opts.inspect
        #   env = {}
        #   if workstation_resource[:user]
        #     run_opts[:user] = workstation_resource[:user]
        #     # Certain versions of `git` misbehave if git configuration is
        #     # inaccessible in $HOME. We need to ensure $HOME matches the
        #     # user who is executing `git` not the user running Chef.
        #     env['HOME'] = get_homedir(workstation_resource[:user])
        #   end
        #   run_opts[:group] = workstation_resource[:group] if workstation_resource[:group]
        #   env['GIT_SSH'] = workstation_resource[:ssh_wrapper] if workstation_resource[:ssh_wrapper]
        #   run_opts[:log_tag] = workstation_resource[:log_tag] if workstation_resource[:log_tag]
        #   run_opts[:timeout] = workstation_resource[:timeout] if workstation_resource[:timeout]
        #   env.merge!(workstation_resource[:environment_variables]) if workstation_resource[:environment_variables]
        #   run_opts[:timeout] = workstation_resource[:timeout] if workstation_resource[:timeout]
        #   run_opts[:environment] = env unless env.empty?
        #   run_opts[:live_stream] = $stdout if run_opts[:live] || run_opts[:as_system] || run_opts[:as_exit]
        #   run_opts[:live_stream] = $stdout if run_opts[:live]
        #   super(run_opts)
        # end

        # def base_command(command, args = [], run_opts = {})
        #   # logger.trace "running #{chef_command}"
        #   final_command, final_run_options = main_command(command, args, run_opts)

        #   if respond_to?('shell_out!')
        #     warning_worklog('Using shell_out! as executer')
        #     [shell_out!(final_command, final_run_options)]
        #   else
        #     # warning_worklog('Using Mixlib::ShellOut as executer')
        #     shell_command = Mixlib::ShellOut.new(final_command, final_run_options)
        #     shell_command.run_command
        #     # worklog shell_command.inspect
        #     # output = shell_command.stdout
        #     # output += "\nSTDERR: #{shell_command.stderr}" unless shell_command.error?
        #     shell_command.stdout
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
#     extend ChefWorkstationInitialize::CommandlineHelpers
#
#     my_helper_method
#
# You may also add this to a single resource within a recipe:
#
#     template '/etc/app.conf' do
#       extend ChefWorkstationInitialize::CommandlineHelpers
#       variables specific_key: my_helper_method
#     end
#
