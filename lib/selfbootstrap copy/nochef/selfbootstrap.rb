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

        attr_accessor :force_solo

        def for_solo?
          is_knife? && ARGV.join(' ').include?('config show solo --format json')
        end

        def for_search_local_node?
          is_knife? && ARGV.join(' ').include?("search node name:#{default_hostname} --format json -z")
        end

        def is_self_bootsrapping?
          is_kitchen_command? && ARGV.join(' ').include?('list bootstrap self')
        end

        def is_boostrapping?
          ::File.exist?(bootstrapping_progress_file)
        end

        def unauthorized_to_boostrap?
          is_chef_command? || is_chef_client_command? || is_chef_cli_command?
        end

        def run_as_root?
          ENV['USER'] == 'root' # workstation_resource[:user] == 'root'
        end

        def skip_boostrap?
          debug_worklog("for_solo = #{for_solo?}")
          debug_worklog("for_search_local_node = #{for_search_local_node?}")
          debug_worklog("unauthorized_to_boostrap = #{unauthorized_to_boostrap?}")
          # debug_worklog("is_boostrapping = #{is_boostrapping?}")
          for_solo? || for_search_local_node? || unauthorized_to_boostrap? # || is_boostrapping?
        end

        def chef_solo_options
          solo_options.each do |opt, value|
            send(opt, JSON.generate(JSON.generate(value).encode)) unless value.nil? || !respond_to?(opt)
          end
        end

        def chef_solo_options_encode
          chef_solo_options_str = ''
          solo_options.each do |opt, value|
            chef_solo_options_str += "#{opt} #{JSON.generate(JSON.generate(value).encode)}\n"
          end
          chef_solo_options_str
        end

        def chef_solo_options_command
          solo_options.map do |opt, value|
            if opt.to_s == 'solo' && value
              '--local-mode'
            else
              encode_value = JSON.generate(value.to_s).encode
              "--config-option #{opt}=#{encode_value}"
            end
          end
        end

        def remove_bootstrap_file
          debug_worklog "deleting \"#{bootstrapping_progress_file}\"(#{is_boostrapping?})}\n" # if run_opts[:debug]
          FileUtils.rm bootstrapping_progress_file if is_boostrapping?
        end

        def install_this_gem
          chef 'gem install selfbootstrap', as_system: true
        end

        def restart_bootstrap
          rerun_opt = { as_exit: true, live: true }
          restart_command = 'selfbootstrap'
          restart_command = "/opt/chef-workstation/embedded/bin/ruby #{ChefWorkstationInitialize::SelfBootstrap.get_start_program}"
          worklog 'Restart bootstrap to reload config'
          caller_worklog
          if run_as_root?
            install_chef_workstation
            set_chef_profile
          else
            worklog 'Self bootstrap with sudo command'
            rerun_opt[:sudo] = true
          end
          install_this_gem
          debug_worklog 'boostrapped with solo and kitchen and root'
          remove_bootstrap_file
          # return_status = base_command(restart_command, ARGV, rerun_opt)
          # case return_status
          # when Integer
          #   exit return_status
          # when String
          #   worklog("­\n\n#{return_status}\n")
          #   caller_worklog
          #   exit 0
          # else
          #   warning_worklog("return_status as #{return_status.class} = #{return_status}")
          #   exit 5
          # end
          # kitchen 'list bootstrap self', sudo: true
          base_command(restart_command, ARGV, rerun_opt)
          worklog "\n\nNEVER SUPPOSSED TO SEE THAT!!!!!\n\n"
        end

        def set_chef_profile
          bash_file = '/etc/bash.bashrc'
          # chef_shell_cmd = "cd #{workstation_scripts_dir}; curl -L https://omnitruck.chef.io/install_desktop.sh | sudo bash -s -- #{project_name} #{environments.join(' ')}"
          chef_shell_cmd = 'eval "$(chef shell-init bash)"'
          debug_worklog "Set chef profile to #{bash_file}"
          open(bash_file, 'a') do |f|
            f.puts chef_shell_cmd
          end unless ::File.read(bash_file).include?(chef_shell_cmd)
        end

        # def generate_workstation_berksfile
        #   ::File.write(workstation_berksfile, '+w') do |file|
        #     source 'https://supermarket.chef.io'
        #     file << "cookbook 'infra_chef', '~> 0.1.0', git: 'git@github.com:jimbodragon/infra_chef.git'"
        # end

        def chef_client_self_bootstrap_cmd
          debug_worklog 'boostrapped with solo and chef-client'

          # generate_workstation_berksfile
          generate_policy 'infra_chef'
          render_template(::File.join(get_path(workstation_solo_d_dir), ::File.join(project_name, project_name + '.rb')), 'solo.rb.erb', workstation: self)
          chef_client_options = [self_bootstrap_options]
          # chef_client_options << '--runlist infra_chef'
          chef_client_options << '--named-run-list ' + 'infra_chef'
          if ::File.exist?('solo.rb')
            chef_client_options << '-c solo.rb'
          else
            chef_solo_options_command.each do |option|
              chef_client_options << option
            end
            # chef_client_options << "--chef-zero-host #{default_hostname}"
            # chef_client_options << "--chef-zero-port #{default_chefzero_portrange}"
          end
          debug_worklog "chef_client_options #{chef_client_options.join("\n")}"
          chef_client chef_client_options, live: true, as_system: true
        end

        def load_chef
          if is_chefworkstation_available?
            require 'kitchen'
            require 'chef'
            require 'chef/workstation_config_loader'

            extend ChefWorkstationInitialize::SelfBootstrap::WithMixLib
            load_chef
          end
        end

        def bootstrap_self_command
          if run_as_root?
            load_chef
            bootstrap_self_command
          else
            restart_bootstrap
          end
          debug_worklog 'bootstrap self command completed'
        end

        def boostrapp_once
          create_chef_additionnal_dir
          # berks_vendor_init if ::File.exist?(workstation_berksfile)
          # unless is_boostrapping?
          #   FileUtils.touch bootstrapping_progress_file
          #   change_unix_permission
          #   bootstrap_self_command
          #   change_unix_permission
          #   remove_bootstrap_file
          # end
          change_unix_permission
          bootstrap_order
          change_unix_permission
        end

        def bootstrap_self
          # worklog "Bootstrap #{default_hostname} with skip #{skip_boostrap?}::#{boostrapped?}"
          debug_worklog("$LOAD_PATH = #{$LOAD_PATH.join("\n")}")
          unless skip_boostrap? || boostrapped?
            worklog 'machine not boostrapped'
            boostrapp_once
          end
        end

        def is_solo?
          workstation_resource[:solo]
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

        def solo_options
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
            node_name: default_hostname,
            ohai_segment_plugin_path: get_path(workstation_ohai_segment_plugin_path),
            solo_d_dir: get_path(workstation_solo_d_dir),
            user: workstation_resource[:user],
            user_home: workstation_resource[:home],
            user_path: get_path(workstation_user_path),
            syntax_check_cache_path: get_path(workstation_syntax_check_cache_path),
            trusted_certs_dir: get_path(workstation_trusted_certs_dir),
            validation_client_name: "#{project_name}-chef-validator",
            data_bag_encrypt_version: 3,
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

