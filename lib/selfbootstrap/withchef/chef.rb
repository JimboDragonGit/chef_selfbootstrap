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

require_relative 'git'

module ChefWorkstationInitialize
  module SelfBootstrap
    module WithChef
      module ChefHelpers
        include ChefWorkstationInitialize::SelfBootstrap::WithChef::GitHelpers

        def generate_secret_databag(databag_name, item_name)
          generate_databag(databag_name, item_name, { secret: UnixCrypt::SHA512.build(SecureRandom.base64(12)) }, nil, :update)
        end

        def get_databag(databag_name, item_name, secret_databag_item = nil)
          secret = nil
          unless secret_databag_item.nil?
            secret = get_databag(cookbook_name, secret_databag_item)
            if secret.nil?
              # chef_vault_secret "github_ssh_keys" do
              #   data_bag "github"
              #   admins ENV['USER'] # if ENV['USER'] != "root"
              #   clients [node[:name]]
              #   environment node[:chef_environment]
              #   raw_data({ENV['USER'] => {"private_key" => file_open("#{ENV["HOME"]}/.ssh/id_rsa.pub")}})
              #   search "*:*"
              #   action :create
              # end
              generate_secret_databag(cookbook_name, secret_databag_item)
              secret = get_databag(cookbook_name, secret_databag_item)['secret']
            end
          end

          case ChefVault::Item.data_bag_item_type(databag_name, item_name)
          when :normal || :encrypted
            data_bag_item(databag_name, item_name, secret)
          when :vault
            ChefVault::Item.load(databag_name, item_name)
          end unless data_bag(databag_name).nil? || data_bag(databag_name).empty? || !data_bag(databag_name).include?(item_name)
        end

        def generate_databag(databag_name, item_name, raw_databag, secret_databag_item = nil, databag_action = :create)
          chef_data_bag databag_name

          generate_secret_databag(cookbook_name, secret_databag_item) unless secret_databag_item.nil?

          debug_worklog("Generating databag #{databag_name} for item #{item_name} using the secret #{secret_databag_item.nil? ? 'no secret' : "#{get_databag(cookbook_name, secret_databag_item)['secret']} using encryption version #{Chef::Config[:data_bag_encrypt_version]}"} containing #{raw_databag}")

          chef_data_bag_item item_name do
            raw_json raw_databag
            data_bag databag_name
            unless secret_databag_item.nil?
              encryption_version Chef::Config[:data_bag_encrypt_version].nil? ? 3 : Chef::Config[:data_bag_encrypt_version]
              secret get_databag(cookbook_name, secret_databag_item)['secret']
              encrypt true
            end
          end

          if databag_action == :update
            # dtbg = get_databag(databag_name, item_name, secret_databag_item)
            # raw_databag['id'] = item_name if raw_databag['id'].nil?
            # dtbg.raw_data = raw_databag
            # dtbg.save
            ruby_block "Update data bag item #{databag_name}/#{item_name}" do
              block do
                # extend ChefWorkstationInitialize::SelfBootstrap
                extend ChefWorkstationInitialize::ChefHelpers
                dtbg = get_databag(databag_name, item_name, secret_databag_item)
                unless dtbg.nil?
                  raw_databag['id'] = item_name if raw_databag['id'].nil?
                  dtbg.raw_data = raw_databag
                  dtbg.save
                end
              end
              action :run
            end
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
