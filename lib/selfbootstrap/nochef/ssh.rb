#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

require_relative 'commandline'

module ChefWorkstationInitialize
  module SelfBootstrap
    module NoChef
      module SSHHelpers
        include ChefWorkstationInitialize::SelfBootstrap::NoChef::CommandlineHelpers

        def ssh(*args, **run_opts)
          base_command('ssh', args, run_opts)
        end

        def ssh_keygen(*args, **run_opts)
          base_command('ssh-keygen', args, run_opts)
        end

        def ssh_command(ip_or_name, user, command)
          worklog('Running method ssh_command(ip_or_name, user, command)' + " for class #{self.class} inside file #{__FILE__}")

          ssh "-o StrictHostKeyChecking=no -l #{user} #{ip_or_name} #{command}"
        end

        def delete_hostkey_ip_or_name(ip_or_name)
          worklog('Running method delete_hostkey_ip_or_name(ip_or_name)' + " for class #{self.class} inside file #{__FILE__}")

          debug_worklog 'Delete_ssh_machine_key of ' + ip_or_name.to_s
          ssh_keygen "-R #{ip_or_name}"
        end

        def delete_hostkey
          worklog('Running method delete_hostkey' + " for class #{self.class} inside file #{__FILE__}")

          delete_hostkey_ip_or_name(node['fqdn'])
          delete_hostkey_ip_or_name(node['ipaddress'])
        end

        def generate_private_key(privkey)
          ssh_keygen "-m 'RFC4716' -N '' -P '' -f #{privkey}"
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
#     extend ChefWorkstationInitialize::SshHelpers
#
#     my_helper_method
#
# You may also add this to a single resource within a recipe:
#
#     template '/etc/app.conf' do
#       extend ChefWorkstationInitialize::SshHelpers
#       variables specific_key: my_helper_method
#     end
#
