#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

require_relative 'kitchencommanda'

module SelfBootstrap
  module KnifeCommands
    include SelfBootstrap::KitchenCommands

    def knife(*args, **run_opts)
      base_command('knife', *args, **run_opts)
    end

    def repo_options
      knife %w(config show)
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
      debug_worklog 'boostrapped with chef-server and knife'
      knife "bootstrap #{self_bootstrap_options} --policy-group #{project_name} --policy-name #{project_name} #{default_hostname}", as_system: true
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
