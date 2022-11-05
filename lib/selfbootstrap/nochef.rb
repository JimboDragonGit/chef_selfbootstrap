#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

require 'json'
require 'date'
require 'fileutils'
require 'yaml'
require 'socket'

module SelfBootstrap
  module NoChef
    def is_chefworkstation_available?
      Gem.ruby.include?('/opt/chef-workstation')
    end

    def load_chef
      require_relative 'chefclient'
      if is_chefworkstation_available?
        extend SelfBootstrap::ChefClient
      else
        extend SelfBootstrap::ReloadCommand
        restart_bootstrap
      end
    end

    def get_configuration_data
      load_chef
    end

    def bootstrap_order
      get_configuration_data
      authenticate_to_chef_infra_server
      rebuild_the_node
      expand_run_list
      synchronize_cookbooks
      reset_node_attributes
      compile_resource_collection
      converge_nodes
      update_node
      get_reports
      check_compliance
      wait_until_next_run
    end

    def bootstrap_self
      debug_worklog("$LOAD_PATH = #{$LOAD_PATH.join("\n")}")
      bootstrap_order
    end

    def cookbooks_source
      cookbooksrc = []
      %w(infra_chef chef_workstation_initialize chef-git-server chefserver virtualbox).each do |cookbook|
        cookbooksrc << {
          cookbook.to_sym => {
            source: {
              github: {
                name: "jimbodragon/#{cookbook}",
                branch: 'master',
              },
            },
          },
        }
      end
      cookbooksrc
    end

    def workstation_resource
      {
        install_dir: ::Dir.getwd,
        project_name: ::File.basename(::Dir.getwd),
        cookbook_source: 'infra_chef',
        solo: true,
        data_bag_encrypt_version: 3,
      }
    end

    def method_missing(method_name, *args, &block)
      caller_worklog
      load_chef
      if respond_to? method_name.to_sym
        public_send(method_name, *args, &block)
      else
        super
      end
    end

    def worklog_counter
      @worklog_counter ||= 0
      @worklog_counter += 1
    end

    def worklog(logstr)
      # if skip_boostrap?
      #   create_chef_additionnal_dir unless ::File.exist?(workstation_logs_dir)
      #   ::File.open(::File.join(get_path(workstation_logs_dir), 'knife.log'), 'a+') do |file|
      #     file.puts logstr
      #   end
      # els
      puts("#{DateTime.now} |#{ENV['USER']}| (#{worklog_counter}):: #{logstr}\n")
    end

    def error_worklog(logstr)
      worklog("ERROR:: #{logstr}")
    end

    def warning_worklog(logstr)
      worklog("WARN:: #{logstr}")
    end

    def caller_worklog
      worklog("CALLER:: \n#{caller.join("\n")}\n")
    end

    def debug_worklog(logstr)
      # worklog("DEBUG:: #{logstr}")
    end

    def analyse_object(object)
      begin
        debug_worklog("Analyzing object = #{object.class.name}")
      rescue StandardError => exception
        debug_worklog("StandardError catch for: (#{exception.class.name}): #{exception.message}")
      end
      begin
        debug_worklog("#{object.class.name}.methods = #{object.methods}")
        debug_worklog("Empty = \n\n\n")
      rescue StandardError => exception
        debug_worklog("StandardError catch for: (#{exception.class.name}): #{exception.message}")
      end
      begin
        debug_worklog("#{object.class.name}.singleton_methods = #{object.singleton_methods}")
        debug_worklog("Empty = \n\n\n")
      rescue StandardError => exception
        debug_worklog("StandardError catch for: (#{exception.class.name}): #{exception.message}")
      end
      begin
        debug_worklog("#{object.class.name}.public_constant = #{object.public_constant}")
        debug_worklog("Empty = \n\n\n")
      rescue StandardError => exception
        debug_worklog("StandardError catch for: (#{exception.class.name}): #{exception.message}")
      end
      begin
        debug_worklog("#{object.class.name}.public_class_method = #{object.public_class_method}")
        debug_worklog("Empty = \n\n\n")
      rescue StandardError => exception
        debug_worklog("StandardError catch for: (#{exception.class.name}): #{exception.message}")
      end
      begin
        debug_worklog("#{object.class.name}.singleton_methods = #{object.singleton_methods}")
        debug_worklog("Empty = \n\n\n")
      rescue StandardError => exception
        debug_worklog("StandardError catch for: (#{exception.class.name}): #{exception.message}")
      end
      begin
        debug_worklog("#{object.class.name}.public_methods = #{object.public_methods}")
        debug_worklog("Empty = \n\n\n")
      rescue StandardError => exception
        debug_worklog("StandardError catch for: (#{exception.class.name}): #{exception.message}")
      end
      begin
        debug_worklog("#{object.class.name}.included_modules = #{object.included_modules}")
        debug_worklog("Empty = \n\n\n")
      rescue StandardError => exception
        debug_worklog("StandardError catch for: (#{exception.class.name}): #{exception.message}")
      end
      begin
        debug_worklog("#{object.class.name}.local_variables = #{object.local_variables}")
        debug_worklog("Empty = \n\n\n")
      rescue StandardError => exception
        debug_worklog("StandardError catch for: (#{exception.class.name}): #{exception.message}")
      end
      begin
        debug_worklog("#{object.class.name}.instance_variables = #{object.instance_variables}")
        debug_worklog("Empty = \n\n\n")
      rescue StandardError => exception
        debug_worklog("StandardError catch for: (#{exception.class.name}): #{exception.message}")
      end
      begin
        debug_worklog("#{object.class.name}.global_variables = #{object.global_variables}")
        debug_worklog("Empty = \n\n\n")
      rescue StandardError => exception
        debug_worklog("StandardError catch for: (#{exception.class.name}): #{exception.message}")
      end
      begin
        debug_worklog("#{object.class.name}.class_variables = #{object.class_variables}")
        debug_worklog("Empty = \n\n\n")
      rescue StandardError => exception
        debug_worklog("StandardError catch for: (#{exception.class.name}): #{exception.message}")
      end
      begin
        debug_worklog("#{object.class.name}.constants = #{object.constants}")
      rescue StandardError => exception
        debug_worklog("StandardError catch for: (#{exception.class.name}): #{exception.message}")
      end
      begin
        debug_worklog("#{object.class.name}.params = #{object.resource_name}")
      rescue StandardError => exception
        debug_worklog("StandardError catch for: (#{exception.class.name}): #{exception.message}")
      end
      begin
        debug_worklog("#{object.class.name}.resource_initializing = #{object.resource_initializing}")
      rescue StandardError => exception
        debug_worklog("StandardError catch for: (#{exception.class.name}): #{exception.message}")
      end
      begin
        debug_worklog("#{object.class.name}.resources = #{object.resources}")
      rescue StandardError => exception
        debug_worklog("StandardError catch for: (#{exception.class.name}): #{exception.message}")
      end
      begin
        debug_worklog("#{object.class.name}.params = #{object.params}")
      rescue StandardError => exception
        debug_worklog("StandardError catch for: (#{exception.class.name}): #{exception.message}")
      end
      begin
        debug_worklog("#{object.class.name}.find_resource(\"git_resource[YP]\") = #{object.find_resource(:git_resource, "YP")}")
      rescue StandardError => exception
        debug_worklog("StandardError catch for: (#{exception.class.name}): #{exception.message}")
      end
      # begin
      #   analyse_object(object.find_resource(:git_resource, "YP"), logger)
      # rescue StandardError => exception
      #   debug_worklog("StandardError catch for: (#{exception.class.name}): #{exception.message}")
      # end
      begin
        debug_worklog("Chef::Provider::GitResource.public_class_method(:init_git) = #{Chef::Provider::GitResource.public_class_method(:init_git)}")
      rescue StandardError => exception
        debug_worklog("StandardError catch for: (#{exception.class.name}): #{exception.message}")
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
#     extend SelfBootstrap::NoChefHelpers
#
#     my_helper_method
#
# You may also add this to a single resource within a recipe:
#
#     template '/etc/app.conf' do
#       extend SelfBootstrap::NoChefHelpers
#       variables specific_key: my_helper_method
#     end
#
