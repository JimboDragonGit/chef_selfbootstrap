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

require 'json'
require 'date'
require 'fileutils'
require 'yaml'
require 'socket'

module ChefWorkstationInitialize
  module SelfBootstrap
    module NoChef
      module DefaultMethodsHelpers
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
  end
end
