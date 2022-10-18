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

require_relative 'chefrepo'

module ChefWorkstationInitialize
  module SelfBootstrap
    module WithChef
      module UsersHelpers
        include ChefWorkstationInitialize::SelfBootstrap::WithChef::ChefRepoHelpers

        def create_user(user, user_data)
          user user do
            extend Vbox::Helpers
            extend UnixCrypt
            debug_worklog("user_data = #{user_data[:password]}")
            username user
            gid workstation_resource[:group]
            password UnixCrypt::SHA512.build(user_data[:password])
            home user_data[:home]
            shell user_data[:shell]
            system user_data[:system]
            manage_home user_data[:manage_home]
          end
        end

        def create_group(groupname, groupcomment, users)
          group groupname do
            comment "#{groupname} #{groupcomment}"
            action [:create, :modify]
            append true
            members users
          end
        end

        def generate_user_data(user, home = '')
          extend ChefHelpers

          if home.nil? || (home.is_a?(String) ? home.empty? : home)
            home = ::File.join(::File.join('/', 'home'), user)
          end

          begin
            user_data = get_databag(userdatabag, user, secretdatabagitem)
          rescue Net::HTTPServerException => exception
            user_data = nil
          end
          if user_data.nil?
            node_user = node['infra_chef']['devops'][user]
            user_data = {
              name: user,
              home: home,
              password: SecureRandom.base64(16),
              chefadmin: node_user.nil? == false ? !node_user['firstname'].empty? : false,
              shell: ::File.join(::File.join('/', 'bin'), 'bash'),
              system: true,
              manage_home: true,
            }
            unless node_user.nil?
              %w(name chefadmin shell system manage_home firstname lastname home email).each do |user_attr|
                user_data[user_attr] = node_user[user_attr] if node_user[user_attr]
              end

              home = user_data['home'] if node_user['home']
            end
            generate_ssh_user_key(user, user_data)

            sshdir = ::File.join(home, '.ssh')
            privkey = ::File.join(sshdir, 'id_rsa')
            pubkey = ::File.join(sshdir, 'id_rsa.pub')
            authorisationkeysfile = ::File.join(sshdir, 'authorisation_keys')
            knownhostfile = ::File.join(sshdir, 'known_host')

            user_data.deep_merge({
              decompose_public_key: {
                key: file_read(pubkey).split(' ')[1],
                keytype: file_read(pubkey).split(' ')[0],
                comment: file_read(pubkey).split(' ')[2],
              },
              authorisation_keys: file_exist?(authorisationkeysfile) ? file_read(authorisationkeysfile) : '',
              known_host: file_exist?(knownhostfile) ? file_read(knownhostfile) : '',
              private_key: file_read(privkey),
              public_key: file_read(pubkey),
            })
          else
            user_data = user_data.raw_data
          end
          user_data
        end

        def generate_secret
          chef_gem 'unix-crypt'
          chef_gem 'ruby-shadow'
          chef_gem 'securerandom'

          require 'unix_crypt'
          require 'shadow'
          require 'securerandom'

          ssh_known_hosts_entry 'localhost'
          ssh_known_hosts_entry '127.0.0.1'
          ssh_known_hosts_entry node['ipaddress']
          ssh_known_hosts_entry node['fqdn']
          ssh_known_hosts_entry 'github.com'

          generate_databag(userdatabag, ENV['USER'], generate_user_data(ENV['USER'], ENV['HOME']), secretdatabagitem, :update) unless ENV['USER'] == 'root' && (ENV['HOME'] == '/home/vagrant' || ENV['HOME'] == '/root')
          generate_databag(userdatabag, workstation_resource[:user], generate_user_data(workstation_resource[:user], workstation_resource[:home]), secretdatabagitem, :update)
          node['infra_chef']['devops'].each_key do |chef_user|
            generate_databag(userdatabag, chef_user, generate_user_data(chef_user), secretdatabagitem, :update)
          end
        end

        def set_cookbook_user_secret_key
          %w(chefserver virtualbox).each do |cookbook_attribute|
            node.override[cookbook_attribute]['userdatabag'] = userdatabag
            node.override[cookbook_attribute]['secretdatabag'] = secretdatabag
            node.override[cookbook_attribute]['secretdatabagitem'] = secretdatabagitem
            node.override[cookbook_attribute]['secretdatabagkey'] = secretdatabagkey
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
