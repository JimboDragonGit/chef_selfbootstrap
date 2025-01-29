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
    module WithChef
      module WorkstationHelpers
        include ChefWorkstationInitialize::SelfBootstrap::WithChef::UsersHelpers

        def auto_repo(auto_repo_action = nil, auto_repo_compile_time = false)
          auto_chef_repo workstation_resource[:project_name] do
            extend DefaultValuesHelpers
            install_dir workstation_resource[:install_dir] unless workstation_resource[:install_dir].nil?
            project_name workstation_resource[:project_name] unless workstation_resource[:project_name].nil?
            project_description workstation_resource[:project_description] unless workstation_resource[:project_description].nil?
            environments workstation_resource[:environments] unless workstation_resource[:environments].nil?
            initial_command workstation_resource[:initial_command] unless workstation_resource[:initial_command].nil?
            cron_chef_solo_command workstation_resource[:cron_chef_solo_command] unless workstation_resource[:cron_chef_solo_command].nil?
            chef_boostrapped workstation_resource[:chef_boostrapped] unless workstation_resource[:chef_boostrapped].nil?
            environment workstation_resource[:environment] unless workstation_resource[:environment].nil?
            user workstation_resource[:user] unless workstation_resource[:user].nil?
            group workstation_resource[:group] unless workstation_resource[:group].nil?
            home workstation_resource[:home] unless workstation_resource[:home].nil?
            run_for_type workstation_resource[:run_for_type] unless workstation_resource[:run_for_type].nil?
            gitinfo workstation_resource[:gitinfo] unless workstation_resource[:gitinfo].nil?
            cron workstation_resource[:cron] unless workstation_resource[:cron].nil?
            provisioners workstation_resource[:provisioners] unless workstation_resource[:provisioners].nil?
            verifiers workstation_resource[:verifiers] unless workstation_resource[:verifiers].nil?
            platforms workstation_resource[:platforms] unless workstation_resource[:platforms].nil?
            suites workstation_resource[:suites] unless workstation_resource[:suites].nil?
            default_attributes workstation_resource[:default_attributes] unless workstation_resource[:default_attributes].nil?
            override_attributes workstation_resource[:override_attributes] unless workstation_resource[:override_attributes].nil?
            action auto_repo_action unless auto_repo_action.nil?
            compile_time auto_repo_compile_time
            optional_actions yield if block_given?
            # infra:,
          end
        end

        def node_infra_chef
          if parent_nil?(node, 'infra_chef', 'project_name')
            node.override['infra_chef']['project_name'] = cookbook_name
            node.override['infra_chef']['install_dir'] = workstation_chef_repo_path
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
