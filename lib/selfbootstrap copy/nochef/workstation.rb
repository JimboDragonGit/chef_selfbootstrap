#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

require_relative 'users'

module ChefWorkstationInitialize
  module SelfBootstrap
    module NoChef
      module WorkstationHelpers
        include ChefWorkstationInitialize::SelfBootstrap::NoChef::UsersHelpers

        attr_reader :workstationobj

        def auto_repo(auto_repo_action = nil, auto_repo_compile_time = false)
          require_implement_method('auto_repo', %w(auto_repo_action auto_repo_compile_time))
        end

        def node_infra_chef
          require_implement_method('node_infra_chef', [])
        end

        def project_name
          workstation_resource[:project_name]
        end

        def workstation_chef_repo_path
          if ::File.basename(default_install_dir) == project_name
            default_install_dir
          else
            ::File.join(get_path(install_dir), project_name)
          end
        end

        def workstation_cookbooks_dir
          ::File.join(get_path(workstation_chef_repo_path), 'cookbooks')
        end

        def workstation_config_dir
          ::File.join(get_path(workstation_chef_repo_path), '.chef')
        end

        def workstation_cache_path
          ::File.join(get_path(workstation_config_dir), 'local-mode-cache')
        end

        def workstation_cache_options_syntaxe_path
          ::File.join(get_path(workstation_config_dir), 'syntaxcache')
        end

        def workstation_checksum_path
          ::File.join(get_path(workstation_cache_path), 'checksums')
        end

        def workstation_acl_path
          ::File.join(get_path(workstation_chef_repo_path), 'acls')
        end

        def workstation_client_d_dir
          ::File.join(get_path(workstation_config_dir), 'client.d')
        end

        def workstation_client_key_path
          ::File.join(get_path(workstation_chef_repo_path), 'client_keys')
        end

        def workstation_client_path
          ::File.join(get_path(workstation_chef_repo_path), 'clients')
        end

        def workstation_config_d_dir
          ::File.join(get_path(workstation_config_dir), 'config.d')
        end

        def workstation_container_path
          ::File.join(get_path(workstation_chef_repo_path), 'containers')
        end

        def workstation_cookbook_artifact_path
          ::File.join(get_path(workstation_chef_repo_path), 'cookbook_artifacts')
        end

        def workstation_file_backup_path
          ::File.join(get_path(workstation_cache_path), 'backup')
        end

        def workstation_group_path
          ::File.join(get_path(workstation_chef_repo_path), 'groups')
        end

        def workstation_ohai_segment_plugin_path
          ::File.join(::File.join(get_path(workstation_config_dir), 'ohai'), 'cookbook_plugins')
        end

        def workstation_solo_d_dir
          ::File.join(get_path(workstation_config_dir), 'solo.d')
        end

        def workstation_user_path
          ::File.join(get_path(workstation_chef_repo_path), 'users')
        end

        def workstation_syntax_check_cache_path
          ::File.join(get_path(workstation_config_dir), 'syntaxcache')
        end

        def workstation_trusted_certs_dir
          ::File.join(get_path(workstation_config_dir), 'trusted_certs')
        end

        def workstation_file_cache_path
          ::File.join(get_path(workstation_cache_path), 'cache')
        end

        def workstation_logs_dir
          ::File.join(get_path(workstation_chef_repo_path), 'logs')
        end

        def workstation_libraries_dir
          ::File.join(get_path(workstation_chef_repo_path), 'libraries')
        end

        def workstation_file
          ::File.join(get_path(workstation_libraries_dir), 'selfbootstrap.rb')
        end

        def workstation_resources_dir
          ::File.join(get_path(workstation_chef_repo_path), 'resources')
        end

        def workstation_generators_dir
          ::File.join(get_path(workstation_chef_repo_path), 'generators')
        end

        def workstation_berks_vendor_dir
          ::File.join(get_path(workstation_chef_repo_path), 'berks-cookbooks')
        end

        def workstation_berksfile
          ::File.join(get_path(workstation_chef_repo_path), 'Berksfile')
        end

        def workstation_roles_dir
          ::File.join(get_path(workstation_chef_repo_path), 'roles')
        end

        def workstation_nodes_dir
          ::File.join(get_path(workstation_chef_repo_path), 'nodes')
        end

        def workstation_chef_environments_dir
          ::File.join(get_path(workstation_chef_repo_path), 'environments')
        end

        def workstation_scripts_dir
          ::File.join(get_path(workstation_chef_repo_path), 'scripts')
        end

        def workstation_data_bags_dir
          ::File.join(get_path(workstation_chef_repo_path), 'data_bags')
        end

        def workstation_cache_dir
          ::File.join(get_path(workstation_chef_repo_path), 'cache')
        end

        def workstation_download_dir
          ::File.join(get_path(workstation_chef_repo_path), 'download')
        end

        def workstation_policy_dir
          ::File.join(get_path(workstation_chef_repo_path), 'policies')
        end

        def workstation_policy_group_dir
          ::File.join(get_path(workstation_chef_repo_path), 'policy_group')
        end

        def workstation_policy_files_dir
          ::File.join(get_path(workstation_chef_repo_path), 'policyfiles')
        end

        def bootstrapping_progress_file
          ::File.join(get_path(workstation_chef_repo_path), 'bootstrapping_in_progress')
        end

        def main_generator_name
          "#{project_name}_generator"
        end

        def create_main_generator
          create_generator(main_generator_name)
        end

        def new_cookbook_name
          worklog("Get cookbook_name between #{cookbook_name} and #{project_name}_#{cookbook_name}")
          cookbook_name.include?(project_name) ? cookbook_name : "#{project_name}_#{cookbook_name}"
        end

        def change_unix_permission
          [
            "chown -R #{workstation_resource[:user]}:#{workstation_resource[:group]} #{get_path(workstation_chef_repo_path)}",
            "find #{get_path(workstation_chef_repo_path)} -type d -exec chown -R #{workstation_resource[:user]}:#{workstation_resource[:group]} {} \\;",
            "find #{get_path(workstation_chef_repo_path)} -type d -exec chmod 775 {} \\;",
            "find #{get_path(workstation_chef_repo_path)} -type f -exec chown -R #{workstation_resource[:user]}:#{workstation_resource[:group]} {} \\;",
            "find #{get_path(workstation_chef_repo_path)} -type f -exec chmod g+w {} \\;",
          ].each do |permission_command|
            base_command(permission_command, [], { sudo: true, as_system: true })
            debug_worklog("Change unix permission :: #{permission_command}")
          end
        end

        def prepare_new_resource
          node_infra_chef
          set_cookbook_user_secret_key
          generate_directory(workstation_chef_repo_path)
          # include_recipe "#{new_cookbook_name}::#{workstation_resource[:environment]}" if new_cookbook_name.include?(project_name)
          # include_recipe "#{new_cookbook_name}::#{project_name}" unless includes_recipe? new_cookbook_name.include?(project_name)
          # generate_machine('chefserver')
          debug_worklog("workstation_resource[:infra] = #{workstation_resource[:infra]}")
          # unless workstation_resource[:infra].nil?
          #   worklog("Running workstation_resource[:infra]")
          #   workstation_resource[:infra]
          # end
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
  #     extend ChefWorkstationInitialize::WorkstationHelpers
  #
  #     my_helper_method
  #
  # You may also add this to a single resource within a recipe:
  #
  #     template '/etc/app.conf' do
  #       extend ChefWorkstationInitialize::WorkstationHelpers
  #       variables specific_key: my_helper_method
  #     end
  #
