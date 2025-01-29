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

        def is_mixlib_enabled?
          const_defined? :Mixlib
        end

        def find_program(programname)
          if programname.start_with? '/'
            programname
          else
            base_command('which', programname, as_data: true)
          end
        end

        def main_command(command, args = [], run_opts = {})
          main_command = [command, args].compact.join(' ')
          main_command = "sudo su -c '#{main_command.to_s}'" if run_opts[:sudo]
          debug_worklog "running \"#{main_command}\" from a shell terminal with user #{ENV['USER']}\n" # if run_opts[:debug]
          [main_command, run_options(run_opts)]
        end

        def base_command(command, args = [], run_opts = { as_data: true })
          debug_worklog "executing command #{command}"
          as_system = run_opts[:as_system]
          as_exit = run_opts[:as_exit]
          as_fork = run_opts[:as_fork]
          as_data = run_opts[:as_data]

          final_command, final_run_options = main_command(command, args, run_opts)
          if as_system
            debug_worklog "Using system to run command #{final_command}"
            exit_status = system(final_command, final_run_options)
            if exit_status.nil?
              1
            elsif exit_status.is_a?(Integer)
              exit_status
            elsif exit_status.is_a?(TrueClass)
              0
            elsif exit_status.is_a?(FalseClass)
              2
            else
              warning_worklog("exit_status is a #{exit_status.class} with value #{exit_status}")
              caller_worklog
              3
            end
          elsif as_exit
            debug_worklog "Using exec to run command #{final_command}"
            exec(final_command)
          elsif as_fork
            debug_worklog "Using fork to run command #{final_command}"
            fork(final_command)
          elsif as_data
            debug_worklog "Using backtick to run command #{final_command}"
            `#{final_command}`
          else
            error_worklog('Cannot continue without at least a MixLib is activated to run command ' + final_command)
            # prepend ChefWorkstationInitialize::SelfBootstrap::WithMixLib
            # base_command(command, args, run_opts)
            restart_bootstrap
            exit 4
          end
        end

        def run_options(run_opts = {})
          # debug_worklog run_opts.inspect
          %W(sudo live debug as_system as_exit as_fork as_data environment user group live_stream).each do |key|
            run_opts.delete key.to_sym if run_opts.key? key.to_sym
          end
          # run_opts[:environment] = ENV if run_opts[:environment].nil? || run_opts[:environment].empty?
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
