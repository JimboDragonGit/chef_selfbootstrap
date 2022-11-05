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

require_relative '../withmixlib'
require_relative '../withchefsolo'

module ChefWorkstationInitialize
  module SelfBootstrap
    module WithChef
      module DefaultMethodsHelpers
        # include ChefWorkstationInitialize::SelfBootstrap::WithMixLib

        def method_missing(method_name, *args, &block)
          caller_worklog
          if is_solo?
            prepend ChefWorkstationInitialize::SelfBootstrap::WithChefSolo
            method_missing(method_name, *args, &block)
          else
            super
          end
        end

        def generate_directory(dir_path)
          if respond_to? :directory
            directory get_path(dir_path) do
              group workstation_resource[:group]
              mode '0775'
              recursive true
            end
          else
            super(dir_path)
          end
        end

        def worklog(logstr)
          ::Chef::Log.warn("|#{ENV['USER']}| (#{worklog_counter}):: #{logstr}")
        end
      end
    end
  end
end
