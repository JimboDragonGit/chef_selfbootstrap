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
          run_opts[:group] = workstation_resource[:group] if workstation_resource[:group]
          env['GIT_SSH'] = workstation_resource[:ssh_wrapper] if workstation_resource[:ssh_wrapper]
          run_opts[:log_tag] = workstation_resource[:log_tag] if workstation_resource[:log_tag]
          run_opts[:timeout] = workstation_resource[:timeout] if workstation_resource[:timeout]
          env.merge!(workstation_resource[:environment_variables]) if workstation_resource[:environment_variables]
          run_opts[:environment] = env unless env.empty?
          super(run_opts)
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
