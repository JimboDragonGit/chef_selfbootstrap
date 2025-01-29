#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

require_relative 'chefrepooptions'

module SelfBootstrap
  module ChefRepo
    include SelfBootstrap::ChefRepoOptions

    def load_chef
      super
      if is_chefworkstation_available?
        require 'chef'
        require 'chef/workstation_config_loader'
      end
    end

    def workstation_resource
      if Chef::Config[:selfbootstrap].nil?
        config_loader = ChefConfig::WorkstationConfigLoader.new(nil)
        Chef::Config.from_file(config_loader.config_location) unless config_loader.config_location.nil?
        Chef::Config[:selfbootstrap] = super if Chef::Config[:selfbootstrap].nil?
        workstation_resource
      end
      Chef::Config[:selfbootstrap]
    end

    def reset_berks_vendor_dir
      FileUtils.rm_rf(workstation_berks_vendor_dir)
      generate_directory workstation_berks_vendor_dir
    end

    def create_chef_additionnal_dir
      generate_directory workstation_logs_dir
      generate_directory workstation_generators_dir

      generate_directory workstation_chef_repo_path
      generate_directory workstation_cookbooks_dir
      generate_directory workstation_libraries_dir
      generate_directory workstation_resources_dir
      generate_directory workstation_berks_vendor_dir
      generate_directory workstation_data_bags_dir
      generate_directory workstation_chef_environments_dir
      generate_directory workstation_nodes_dir
      generate_directory workstation_policy_group_dir
      generate_directory workstation_policy_dir
      generate_directory workstation_policy_files_dir
      generate_directory workstation_roles_dir
      generate_directory workstation_cache_options_syntaxe_path
      generate_directory workstation_cache_path
      generate_directory workstation_checksum_path
      generate_directory workstation_acl_path
      generate_directory workstation_client_d_dir
      generate_directory workstation_client_key_path
      generate_directory workstation_client_path
      generate_directory workstation_config_d_dir
      generate_directory workstation_config_dir
      generate_directory workstation_container_path
      generate_directory workstation_cookbook_artifact_path
      generate_directory workstation_file_backup_path
      generate_directory workstation_file_cache_path
      generate_directory workstation_group_path
      generate_directory workstation_ohai_segment_plugin_path
      generate_directory workstation_solo_d_dir
      generate_directory workstation_user_path
      generate_directory workstation_syntax_check_cache_path
      generate_directory workstation_trusted_certs_dir

      reset_berks_vendor_dir
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
