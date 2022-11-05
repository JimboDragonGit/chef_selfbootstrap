#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

require_relative 'workstationresource'
require_relative '../withmixlib'

module ChefWorkstationInitialize
  module SelfBootstrap
    module NoChef
      module SelfBootstrapHelpers
        include ChefWorkstationInitialize::SelfBootstrap::NoChef::WorkstationResourceHelpers

        def for_solo?
          is_knife? && ARGV.join(' ').include?('config show solo --format json')
        end

        def for_search_local_node?
          is_knife? && ARGV.join(' ').include?("search node name:#{default_hostname} --format json -z")
        end

        def unauthorized_to_boostrap?
          is_chef_command? || is_chef_client_command? || is_chef_cli_command?
        end

        def skip_boostrap?
          for_solo? || for_search_local_node? || unauthorized_to_boostrap?
        end

        def boostrapped?
          return false if for_search_local_node?

          begin
            result = JSON.parse(knife_search_self_cmd)
            debug_worklog('Searching result' + result.to_s)
            rows = result['rows']
            get_runlist = nil
            rows.each do |row|
              unless row['run_list'].nil? || row['run_list'].empty?
                get_runlist ||= []
                get_runlist += row['run_list']
              end
            end

            boostrapped = !get_runlist.nil?
          rescue JSON::ParserError => json_parse_error
            get_runlist = nil
          rescue NoMethodError => no_method_error
            worklog "Not able to execute method: #{no_method_error.inspect}"
            workstation_resource[:solo] = true
            boostrapped = boostrapped?
          rescue StandardError => std_bootstrap_err
            worklog "Not able to validate if bootrapped as: #{std_bootstrap_err.inspect}"
            workstation_resource[:solo] = true
            boostrapped = boostrapped?
          end
          boostrapped
        end

        def boostrapp_once
          bootstrap_order
        end

        def bootstrap_self
          debug_worklog("$LOAD_PATH = #{$LOAD_PATH.join("\n")}")
          bootstrap_order
        end
      end
    end
  end
end
