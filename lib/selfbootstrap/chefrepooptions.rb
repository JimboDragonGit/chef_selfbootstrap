#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

require_relative 'workstation'

module SelfBootstrap
  module ChefRepoOptions
    include SelfBootstrap::Workstation

    def chef_solo_options_encode
      chef_solo_options_str = ''
      repo_options.each do |opt, value|
        chef_solo_options_str += "#{opt} #{JSON.generate(value).encode}\n" unless value.nil?
      end
      chef_solo_options_str
    end

    def repo_options
      {
        chef_repo_path: get_path(workstation_chef_repo_path),
        cookbook_path: [
          get_path(workstation_cookbooks_dir),
          get_path(workstation_libraries_dir),
          get_path(workstation_resources_dir),
          get_path(workstation_berks_vendor_dir),
        ],
        data_bags_path: get_path(workstation_data_bags_dir),
        environment_path: get_path(workstation_chef_environments_dir),
        node_path: get_path(workstation_nodes_dir),
        policy_group_path: get_path(workstation_policy_group_dir),
        policy_path: get_path(workstation_policy_dir),
        role_path: get_path(workstation_roles_dir),
        solo: is_solo?,
        log_location: ::File.join(get_path(workstation_logs_dir), "#{project_name}_#{workstation_resource[:user]}.log"),
        cache_path: get_path(workstation_cache_path),
        checksum_path: get_path(workstation_checksum_path),
        acl_path: get_path(workstation_acl_path),
        client_d_dir: get_path(workstation_client_d_dir),
        client_key_path: get_path(workstation_client_key_path),
        client_path: get_path(workstation_client_path),
        color: true,
        config_d_dir: get_path(workstation_config_d_dir),
        config_dir: get_path(workstation_config_dir),
        container_path: get_path(workstation_container_path),
        cookbook_artifact_path: get_path(workstation_cookbook_artifact_path),
        enable_reporting: false,
        file_backup_path: get_path(workstation_file_backup_path),
        file_cache_path: get_path(workstation_file_cache_path),
        group: workstation_resource[:group],
        group_path: get_path(workstation_group_path),
        lockfile: ::File.join(get_path(workstation_file_cache_path), 'chef-client-running.pid'),
        node_name: hostname,
        ohai_segment_plugin_path: get_path(workstation_ohai_segment_plugin_path),
        solo_d_dir: get_path(workstation_solo_d_dir),
        user: workstation_resource[:user],
        user_home: workstation_resource[:home],
        user_path: get_path(workstation_user_path),
        syntax_check_cache_path: get_path(workstation_syntax_check_cache_path),
        trusted_certs_dir: get_path(workstation_trusted_certs_dir),
        validation_client_name: "#{project_name}-chef-validator",
        data_bag_encrypt_version: 3,
        named_run_list: workstation_resource[:cookbook_source],
        # cache_options: {
        #   'path' => get_path(workstation_cache_options_syntaxe_path),
        # },

        #   # client_key               "#{current_dir}/<%= @workstation_resource[:gitinfo]user %>.pem"
      #   # chef_server_url          "https://chef.jimbodragon.qc.to/organizations/<%= @workstation_resource[:gitinfo]project_name %>"
      #   # acl_path: /root/acls,
      #   # allowed_automatic_attributes: nil,
      #   # allowed_default_attributes: nil,
      #   # allowed_normal_attributes: nil,
      #   # allowed_override_attributes: nil,
      #   # always_dump_stacktrace: false,
      #   # authentication_protocol_version: 1.1,
      #   # automatic_attribute_blacklist: nil,
      #   # automatic_attribute_whitelist: nil,
      #   # blocked_automatic_attributes: nil,
      #   # blocked_default_attributes: nil,
      #   # blocked_normal_attributes: nil,
      #   # blocked_override_attributes: nil,
      #   # cache_options: {
      #   #   path: /root/.chef/syntaxcache
      #   # },
      #   # cache_path: /root/.chef/local-mode-cache,
      #   # checksum_path: /root/.chef/local-mode-cache/checksums,
      #   # chef_guid: nil,
      #   # chef_guid_path: /root/.chef/chef_guid,
      #   # chef_repo_path: /root,
      #   # chef_server_root: chefzero://localhost: 1,
      #   # chef_server_url: chefzero://localhost: 1,
      #   # chef_zero: {
      #   #   enabled: true,
      #   #   host: localhost,
      #   #   osc_compat: false,
      #   #   port: #<Enumerator: 0x000000000136d318>,
      #   #   single_org: chef
      #   # },
      #   # chefcli: nil,
      #   # chefdk: nil,
      #   # clear_gem_sources: nil,
      #   # client_d_dir: /root/.chef/client.d,
      #   # client_fork: nil,
      #   # client_key: nil,
      #   # client_key_contents: nil,
      #   # client_key_path: /root/client_keys,
      #   # client_path: /root/clients,
      #   # client_registration_retries: 5,
      #   # color: true,
      #   # config_d_dir: /root/.chef/config.d,
      #   # config_dir: /root/.chef/,
      #   # config_file: nil,
      #   # container_path: /root/containers,
      #   # cookbook_artifact_path: /root/cookbook_artifacts,
      #   # cookbook_path: [
      #   #   #{current_dir}/cookbooks,
      #   #   #{current_dir}/libraries,
      #   #   #{current_dir}/resources
      #   # ],
      #   # cookbook_sync_threads: 10,
      #   # count_log_resource_updates: false,
      #   # data_bag_decrypt_minimum_version: 0,
      #   # data_bag_encrypt_version: 3,
      #   # data_bags_path: /root/data_bags,
      #   # data_collector: {
      #   #   mode: both,
      #   #   organization: chef_solo,
      #   #   raise_on_failure: false,
      #   #   server_url: nil,
      #   #   token: nil
      #   # },
      #   # default_attribute_blacklist: nil,
      #   # default_attribute_whitelist: nil,
      #   # deployment_group: nil,
      #   # diff_disabled: false,
      #   # diff_filesize_threshold: 10000000,
      #   # diff_output_threshold: 1000000,
      #   # disable_event_loggers: false,
      #   # download_progress_interval: 10,
      #   # enable_reporting: true,
      #   # enable_reporting_url_fatals: false,
      #   # enable_selinux_file_permission_fixup: true,
      #   # encrypted_data_bag_secret: nil,
      #   # enforce_default_paths: false,
      #   # enforce_path_sanity: false,
      #   # environment_path: /root/environments,
      #   # event_handlers: nil,
      #   # event_loggers: nil,
      #   # exception_handlers: nil,
      #   # ez: false,
      #   # file_atomic_update: true,
      #   # file_backup_path: /root/.chef/local-mode-cache/backup,
      #   # file_cache_path: /root/.chef/local-mode-cache/cache,
      #   # file_staging_uses_destdir: auto,
      #   # fips: false,
      #   # follow_client_key_symlink: false,
      #   # force_formatter: false,
      #   # force_logger: false,
      #   # formatter: null,
      #   # formatters: nil,
      #   # group: nil,
      #   # group_path: /root/groups,
      #   # group_valid_regex: (?-mix:^[^-+~: nil,\t\r\n\f\0]+[^: nil,\t\r\n\f\0]*$),
      #   # http_disable_auth_on_redirect: true,
      #   # http_retry_count: 5,
      #   # http_retry_delay: 5,
      #   # internal_locale: C.UTF-8,
      #   # interval: nil,
      #   # json_attribs: nil,
      #   # knife: {
      #   #   hints: nil
      #   # },
      #   # listen: false,
      #   # local_key_generation: true,
      #   # local_mode: true,
      #   # lockfile: /root/.chef/local-mode-cache/cache/chef-client-running.pid,
      #   # log_level: info,
      #   # log_location: STDERR,
      #   # minimal_ohai: false,
      #   # named_run_list: nil,
      #   # no_lazy_load: true,
      #   # node_name: root,
      #   # node_path: /root/nodes,
      #   # normal_attribute_blacklist: nil,
      #   # normal_attribute_whitelist: nil,
      #   # ohai: {
      #   #   critical_plugins: nil,
      #   #   disabled_plugins: nil,
      #   #   hints_path: /etc/chef/ohai/hints,
      #   #   log_level: auto,
      #   #   log_location: #<IO: 0x000000000097b7d8>,
      #   #   optional_plugins: nil,
      #   #   plugin: nil,
      #   #   plugin_path: nil,
      #   #     /opt/chef-workstation/embedded/lib/ruby/gems/2.7.0/gems/ohai-16.6.5/lib/ohai/plugins,
      #   #     /etc/chef/ohai/plugins,
      #   #   run_all_plugins: false,
      #   #   shellout_timeout: 30
      #   # },
      #   # ohai_segment_plugin_path: /root/.chef/ohai/cookbook_plugins,
      #   # once: nil,
      #   # override_attribute_blacklist: nil,
      #   # override_attribute_whitelist: nil,
      #   # pid_file: nil,
      #   # policy_document_native_api: true,
      #   # policy_group: nil,
      #   # policy_group_path: /root/policy_groups,
      #   # policy_name: nil,
      #   # policy_path: /root/policies,
      #   # profile: nil,
      #   # recipe_url: nil,
      #   # repo_mode: hosted_everything,
      #   # report_handlers: nil,
      #   # resource_unified_mode_default: false,
      #   # rest_timeout: 300,
      #   # role_path: /root/roles,
      #   # ruby_encoding: UTF-8,
      #   # rubygems_cache_enabled: false,
      #   # rubygems_url: nil,
      #   # run_lock_timeout: nil,
      #   # script_path: nil,
      #   # show_download_progress: false,
      #   # silence_deprecation_warnings: nil,
      #   # solo: false,
      #   # solo_d_dir: /root/.chef/solo.d,
      #   # solo_legacy_mode: false,
      #   # splay: nil,
      #   # ssh_agent_signing: false,
      #   # ssl_ca_file: nil,
      #   # ssl_ca_path: nil,
      #   # ssl_client_cert: nil,
      #   # ssl_client_key: nil,
      #   # ssl_verify_mode: verify_peer,
      #   # start_handlers: nil,
      #   # stream_execute_output: false,
      #   # syntax_check_cache_path: /root/.chef/syntaxcache,
      #   # target_mode: {
      #   #   enabled: false,
      #   #   protocol: ssh
      #   # },
      #   # treat_deprecation_warnings_as_errors: false,
      #   # trusted_certs_dir: /root/.chef/trusted_certs,
      #   # umask: 18,
      #   # user: nil,
      #   # user_home: /root,
      #   # user_path: /root/users,
      #   # user_valid_regex: (?-mix:^[^-+~: nil,\t\r\n\f\0]+[^: nil,\t\r\n\f\0]*$),
      #   # validation_client_name: chef-validator,
      #   # validation_key: nil,
      #   # validation_key_contents: nil,
      #   # verbose_logging: true,
      #   # verify_api_cert: true,
      #   # why_run: false,
      #   # windows_service: {
      #   #   watchdog_timeout: 7200
      #   # },
      #   # zypper_check_gpg: true,
      }
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
