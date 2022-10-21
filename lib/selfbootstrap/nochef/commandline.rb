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
    module NoChef
      module CommandlineHelpers
        include ChefWorkstationInitialize::SelfBootstrap::NoChef::DefaultMethodsHelpers

        def is_mixlib_disabled?
          !is_chef_constant_enabled? :Mixlib
        end

        def main_command(command, args = [], run_opts = {})
          command = 'sudo ' + command.to_s if run_opts[:sudo]
          main_command = [command, args].compact.join(' ')
          worklog "running \"#{main_command}\" from a shell terminal" # if run_opts[:debug]
          [main_command, run_options(run_opts)]
        end

        def base_command(command, args = [], run_opts = {})
          # logger.trace "running #{chef_command}"
          final_command, final_run_options = main_command(command, args, run_opts)

          if respond_to?('shell_out!')
            warning_worklog('Using shell_out! as executer')
            [shell_out!(final_command, final_run_options)]
          elsif is_mixlib_disabled?
            if run_opts[:as_system]
              warning_worklog "Using system to run command #{final_command}"
              system(final_command)
            else
              error_worklog('Cannot continue without at least a Chef workstation setup to run command ' + final_command)
              restart_bootstrap
              exit 1
            end
          else
            # warning_worklog('Using Mixlib::ShellOut as executer')
            shell_command = Mixlib::ShellOut.new(final_command, final_run_options)
            shell_command.run_command
            # worklog shell_command.inspect
            # output = shell_command.stdout
            # output += "\nSTDERR: #{shell_command.stderr}" unless shell_command.error?
            shell_command.stdout
          end
        end

        def run_options(run_opts = {})
          # debug_worklog run_opts.inspect
          run_opts[:live_stream] = $stdout if run_opts[:live]
          run_opts.delete :sudo if run_opts.key? :sudo
          run_opts.delete :live if run_opts.key? :live
          run_opts.delete :debug if run_opts.key? :debug
          run_opts
        end

        # Returns the home directory of the user
        # @param [String] user must be a string.
        # @return [String] the home directory of the user.
        # from @Chef_16.6.14/provider/git
        #
        def get_homedir(user)
          require 'etc' unless defined?(Etc)
          case user
          when Integer
            Etc.getpwuid(user).dir
          else
            Etc.getpwnam(user.to_s).dir
          end
        end
        #
        # Define the methods that you would like to assist the work you do in recipes,
        # resources, or templates.
        #
        # def my_helper_method
        #   # help method implementation
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
