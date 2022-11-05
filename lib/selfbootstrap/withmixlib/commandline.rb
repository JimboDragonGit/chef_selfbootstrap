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
    module WithMixLib
      module CommandlineHelpers
        include ChefWorkstationInitialize::SelfBootstrap::WithMixLib::DefaultMethodsHelpers

        def run_options(run_opts = {})
          # debug_worklog run_opts.inspect
          env = {}
          if workstation_resource[:user]
            run_opts[:user] = workstation_resource[:user]
            # Certain versions of `git` misbehave if git configuration is
            # inaccessible in $HOME. We need to ensure $HOME matches the
            # user who is executing `git` not the user running Chef.
            env['HOME'] = get_homedir(workstation_resource[:user])
          end
          env['GIT_SSH'] = workstation_resource[:ssh_wrapper] if workstation_resource[:ssh_wrapper]

          unless run_opts[:no_run_option]
            env['GEM_ROOT'] = get_chef_shell('GEM_ROOT')
            env['PATH'] = get_chef_shell('PATH')
          end
          env.merge!(workstation_resource[:environment_variables]) if workstation_resource[:environment_variables]
          run_opts[:environment] = env unless env.empty?

          run_opts[:group] = workstation_resource[:group] if workstation_resource[:group]
          run_opts[:umask] = workstation_resource[:umask] if workstation_resource[:umask]
          run_opts[:log_tag] = workstation_resource[:log_tag] if workstation_resource[:log_tag]
          run_opts[:timeout] = workstation_resource[:timeout] if workstation_resource[:timeout]
          run_opts[:live_stream] = $stdout if run_opts[:live] || run_opts[:as_system] || run_opts[:as_exit]
          %W(as_system as_exit as_fork as_data no_run_option debug live sudo).each do |key|
            run_opts.delete key.to_sym if run_opts.key? key.to_sym
          end
          run_opts
        end

        def run_command(command, args = [], run_opts = {})
          as_debug = run_opts[:debug]
          final_command, final_run_options = main_command(command, args, run_opts)
          shell_command = Mixlib::ShellOut.new(final_command, final_run_options)
          shell_command.run_command
          if as_debug
            debug_worklog "Executing command with MixLib #{final_command}, #{final_run_options} exit with #{shell_command.exitstatus} :: stdout = #{shell_command.stderr} :: stderr = #{shell_command.stderr}"
            caller_worklog
          end
          shell_command
        end

        def base_command(command, args = [], run_opts = {})
          if run_opts[:as_data]
            shell_command = run_command(command, args, run_opts)
            debug_worklog "Return stdout #{shell_command.stdout}"
            shell_command.stdout
          elsif run_opts[:as_exit] || run_opts[:as_system]
            as_exit = run_opts[:as_exit]
            shell_command = run_command(command, args, run_opts)
            debug_worklog "Exit with code #{shell_command.command} => #{shell_command.exitstatus}"
            exit shell_command.exitstatus if as_exit
          else
            super(command, args, run_opts)
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
