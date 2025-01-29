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

require_relative 'update'

module ChefWorkstationInitialize
  module SelfBootstrap
    module NoChef
      module UsersHelpers
        include ChefWorkstationInitialize::SelfBootstrap::NoChef::UpdateHelpers

        def create_user(user, user_data)
          require_implement_method('create_user', %w(user user_data))
        end

        def create_group(groupname, groupcomment, users)
          require_implement_method('create_group', %w(groupname groupcomment users))
        end

        def generate_user_data(user, home = '')
          require_implement_method('generate_user_data', %w(user home))
        end

        def generate_secret
          require_implement_method('generate_secret', [])
        end

        def set_cookbook_user_secret_key
          require_implement_method('set_cookbook_user_secret_key', [])
        end

        def userdatabag
          'users'
        end

        def secretdatabag
          workstation_resource[:cookbook_source]
        end

        def secretdatabagitem
          'cookbook_secret_keys'
        end

        def secretdatabagkey
          'secret'
        end

        def user_fully_created?(user, user_data)
          file_exist?(user_data[:home]) && file_exist?(sshdir) && file_exist?(privkey)
        end

        def generate_ssh_user_key(user, user_data)
          unless user_fully_created?(user, user_data)
            worklog("Generate SSH user key for {#{user}: #{user_data}}")
            sshdir = ::File.join(user_data[:home], '.ssh')
            privkey = ::File.join(sshdir, 'id_rsa')
            create_user(user, user_data)
            groupcomment = 'group for all new_resource user'
            ['docker', workstation_resource[:group]].each do |groupname|
              create_group(groupname, groupcomment)
            end

            ssh_keygen("-m 'RFC4716' -N '' -P '' -f #{privkey}", { user: user, cwd: user_data[:home] })
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
#     extend ChefWorkstationInitialize::ChefHelpers
#
#     my_helper_method
#
# You may also add this to a single resource within a recipe:
#
#     template '/etc/app.conf' do
#       extend ChefWorkstationInitialize::ChefHelpers
#       variables specific_key: my_helper_method
#     end
#

# require_relative "../providers/git_resource"
