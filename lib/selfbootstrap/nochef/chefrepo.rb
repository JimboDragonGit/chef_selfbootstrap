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

require_relative 'kitchen'

module ChefWorkstationInitialize
  module SelfBootstrap
    module NoChef
      module ChefRepoHelpers
        include ChefWorkstationInitialize::SelfBootstrap::NoChef::KitchenHelpers

        def define_cron_job
          require_implement_method('define_cron_job', [])
        end

        def render_template(generated_path, source, **variables)
          require_implement_method('render_template', %w(generated_path source action **variables))
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

        def create_generator(generator_name)
          worklog "Create the chef generator #{generator_name}"
          chef "generate generator #{::File.join(get_path(workstation_generators_dir), generator_name)}", cwd: workstation_generators_dir

          get_git_submodule(generator_name, workstation_resource[:gitinfo]['submodules'][generator_name], :push, workstation_resource[:compile_time]) unless parent_nil?(workstation_resource[:gitinfo], 'submodules', generator_name)
        end

        def create_chef_infra_cookbook
          worklog("Chef Infra cookbook created: #{recipe_name} for #{cookbook_name}")
          create_cookbook(new_cookbook_name)
          create_recipe(new_cookbook_name, workstation_resource[:environment])
          render_template("#{get_git_path(new_cookbook_name)}/recipes/#{workstation_resource[:environment]}.rb", 'default_infra_chef_recipe.erb')

          create_recipe(new_cookbook_name, project_name)
          render_template("#{get_git_path(new_cookbook_name)}/recipes/#{project_name}.rb", 'infra_chef_recipe_vbox.erb')

          create_attribute_file(new_cookbook_name, 'default')
          render_template("#{get_git_path(new_cookbook_name)}/attributes/default.rb", 'default_infra_chef_attribute.erb')

          create_template_file(new_cookbook_name, 'default_infra_chef_attribute')
          create_template_file(new_cookbook_name, 'default_infra_chef_recipe')
          create_template_file(new_cookbook_name, 'infra_chef_recipe_vbox')

          if cookbook_folder != new_cookbook_folder
            worklog "Copy infra chef template for #{new_cookbook_name}"
            cookbook_folder = ::File.join(::File.dirname(::File.dirname(::File.dirname(__FILE__))), cookbook_name)
            template_folder = ::File.join(get_path(cookbook_folder), 'templates')
            new_cookbook_folder = ::File.join(get_path(workstation_cookbooks_dir), new_cookbook_name)
            new_template_folder = ::File.join(get_path(new_cookbook_folder), 'templates')
            ::Dir.each_child(template_folder) do |file|
              ::FileUtils.cp_r(::File.join(get_path(template_folder), file), ::File.join(get_path(new_template_folder), file))
            end
          end

          worklog "Append infraClass in metadata of #{new_cookbook_name}"
          unless file_exist?("#{get_git_path(new_cookbook_name)}/metadata.rb") && file_read("#{get_git_path(new_cookbook_name)}/metadata.rb").grep(/depends 'infra_chef'/).any?
            ::File.open("#{get_git_path(new_cookbook_name)}/metadata.rb", 'a') do |f|
              f.puts "depends 'infra_chef'"
              # f.puts "depends 'infraClass'"
            end
          end

          get_git_submodule(new_cookbook_name, workstation_resource[:gitinfo]['submodules'][new_cookbook_name], :push, workstation_resource[:compile_time]) unless parent_nil?(workstation_resource[:gitinfo], 'submodules', new_cookbook_name)
        end

        def create_cookbook(cookbookname)
          worklog "Create the chef cookbook #{cookbookname}"
          chef "generate cookbook #{cookbookname}", cwd: ::File.dirname(get_git_path(cookbookname))
        end

        def create_recipe(cookbookname, recipe_name)
          worklog "Create recipe #{recipe_name} for #{cookbookname} in path #{get_git_path(cookbookname)}"
          chef "generate recipe #{recipe_name}", cwd: get_git_path(cookbookname)
        end

        def create_attribute_file(cookbookname, attribute_name)
          worklog "Create attribute #{attribute_name} for #{cookbookname} in path #{get_git_path(cookbookname)}"
          chef "generate attribute #{attribute_name}", cwd: get_git_path(cookbookname)
        end

        def create_template_file(cookbookname, template_name)
          worklog "Create attribute #{template_name} for #{cookbookname} in path #{get_git_path(cookbookname)}"
          chef "generate template #{template_name}", cwd: get_git_path(cookbookname)
        end

        def project_role_json
          ensure_main_environment(
            name: project_name,
            description: workstation_resource[:project_description],
            chef_type: 'role',
            json_class: 'Chef::Role',
            default_attributes: workstation_resource[:default_attributes],
            override_attributes: workstation_resource[:override_attributes],
            run_list: [
                new_cookbook_name,
            ]
          )
        end

        def project_environment_json
          ensure_main_environment(
            name: project_name,
            description: workstation_resource[:project_description],
            chef_type: 'environment',
            json_class: 'Chef::Environment',
            default_attributes: workstation_resource[:default_attributes],
            override_attributes: workstation_resource[:override_attributes],
            run_list: [
                new_cookbook_name,
            ]
          )
        end

        def ensure_main_environment(main_role_environment)
          main_role_environment.deep_merge(
            default_attributes: {
              new_cookbook_name: {
              project_name: project_name,
              install_dir: workstation_chef_repo_path,
              gitinfo: workstation_resource[:gitinfo],
              },
            }
          )
        end

        def write_role_environment(path, environment, project_json)
          file ::File.join(get_path(path), "#{environment}.json") do
            content JSON.pretty_generate(project_json)
          end
        end

        def write_main_role
          write_role_environment(workstation_roles_dir, project_name, project_role_json)
        end

        def write_main_environment
          write_role_environment(workstation_chef_environments_dir, workstation_resource[:environment], project_environment_json)
        end

        def write_main_role_environment
          write_main_role
          write_main_environment
        end

        def write_Solo_file
          render_template(::File.join(get_path(workstation_chef_repo_path), 'solo.rb'), 'solo.rb.erb', workstation: self)
          render_template(::File.join(get_path(workstation_chef_repo_path), 'knife.rb'), 'knife.rb.erb', workstation: self)
          render_template(::File.join(get_path(workstation_chef_repo_path), '.gitignore'), 'gitignore.erb', workstation: self)
          render_template(::File.join(get_path(workstation_chef_repo_path), 'chefignore'), 'chefignore.erb', workstation: self)
        end

        def write_kitchen_file
          worklog "Generate policy file #{workstation_resource[:environment]}"
          chef "generate policyfile #{::File.basename(workstation_policy_dir)}/#{workstation_resource[:environment]}", cwd: ::File.dirname(workstation_chef_repo_path)
          worklog('Creating kitchen file')
          render_template(::File.join(get_path(workstation_chef_repo_path), 'kitchen.yml'), 'kitchen.yml.erb', workstation: self)
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
#     extend ChefWorkstationInitialize::ChefHelpers
#
#     my_helper_method
#
# You may also add this to a single resource within a recipe:
#
#     template '/etc/app.conf' do
#       extend ChefWorkstationInitialize::ChefHelpers
#       variables specific_key: my_helper_method
#     end
#

# require_relative "../providers/git_resource"
  