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
      module DefaultValuesHelpers
        def define_resource_requirements
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
          puts("#{DateTime.now}(#{worklog_counter}):: #{logstr}\n")
        end

        def error_worklog(logstr)
          worklog("ERROR:: #{logstr}")
        end

        def warning_worklog(logstr)
          worklog("WARN:: #{logstr}")
        end

        def debug_worklog(logstr)
          worklog("DEBUG:: #{logstr}")
        end

        def require_implement_method(method_name, *arguments)
          warning_worklog("Method '#{method_name}' need to be implement from another module or class with arguments '#{arguments.join(', ')}'")
        end

        def get_path(dir_obj)
          dir_obj.is_a?(::Dir) ? dir_obj.path : dir_obj
        end

        def parent_nil?(hashobject, *names)
          hashobject.nil? ? true : hashobject.depth_nil?(names)
        end

        def default_hostname
          respond_to?('node') ? node['hostname'] : Socket.gethostname
        end

        def default_chefzero_portrange
          '48999-49999'
        end

        def generate_directory(dir_path)
          corrected_dir_path = get_path(dir_path)
          FileUtils.mkdir_p(corrected_dir_path) unless ::File.exist?(corrected_dir_path)
          FileUtils.chown_R(workstation_resource[:user], workstation_resource[:group], corrected_dir_path)
          FileUtils.chmod_R(0775, corrected_dir_path)
          corrected_dir_path
        end

        def get_out_of_folder(folderpath, folder_to_get_out)
          if get_path(folderpath).include?(folder_to_get_out)
            get_out_of_folder(::File.dirname(folderpath))
          else
            folderpath
          end
        end

        def get_out_of_cache_path(cachepath)
          get_out_of_folder(cachepath, 'cache')
        end

        def get_out_of_local_chef_path(projectpath)
          get_out_of_folder(projectpath, '.chef')
        end

        def search_local_project_folder(projectpath)
          get_out_of_local_chef_path(get_out_of_cache_path(projectpath))
        end

        def check_install_dir(dir_to_check)
          if ::File.basename(get_path(dir_to_check)) == project_name
            search_local_project_folder(dir_to_check)
          else
            ::File.join(get_path(dir_to_check), project_name)
          end
        end

        def generate_default_install_dir
          generic_install_dir = '/usr/local/chef/repo'
          # generate_directory default_install_dir
          ::Dir.exist?(generic_install_dir) ? ::Dir.new(generic_install_dir) : generic_install_dir
        end

        def default_install_dir
          if @workstation.nil?
            working_dir = ::Dir.getwd
            install_path = search_local_project_folder(working_dir)
            if ::Dir.exist?(install_path)
              ::Dir.new(install_path)
            else
              error_worklog("Unable to get the project from '#{install_path}' while in the folder #{working_dir}")
            end
          # elsif respond_to?('node')
          #   check_install_dir ::Dir.new("/usr/local/chef/repo/#{node['infra_chef']['project_name']}")
          elsif workstation_resource[:install_dir].nil?
            debug_worklog('workstation defined but install_dir not define')
            generate_default_install_dir
          else
            check_install_dir workstation_resource[:install_dir]
          end
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
