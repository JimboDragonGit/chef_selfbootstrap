#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

require_relative 'mixlib'

module SelfBootstrap
  module Commands
    include SelfBootstrap::MixLib

    def is_mixlib_enabled?
      const_defined? :Mixlib
    end

    def is_with_chefsolo?
      is_with_mixlib? && is_chef_enabled?
    end

    def run_as_root?
      ENV['USER'] == 'root' # workstation_resource[:user] == 'root'
    end

    def install_chef_workstation
      base_command('curl -L https://omnitruck.chef.io/install.sh | bash -s -- -s once -P chef-workstation', [], as_system: true)
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

    def generate_directory(dir_path)
      corrected_dir_path = get_path(dir_path)
      FileUtils.mkdir_p(corrected_dir_path) unless ::File.exist?(corrected_dir_path)
      FileUtils.chown_R(workstation_resource[:user], workstation_resource[:group], corrected_dir_path)
      FileUtils.chmod_R(0775, corrected_dir_path)
      corrected_dir_path
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
