#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

require_relative 'chefrepo'

module SelfBootstrap
  module ChefSolo
    include SelfBootstrap::ChefRepo

    def is_with_chefsolo?
      is_with_mixlib? && is_chef_enabled?
    end

    def get_path(dir_obj)
      dir_obj.is_a?(::Dir) ? dir_obj.path : dir_obj
    end

    def parent_nil?(hashobject, *names)
      hashobject.nil? ? true : hashobject.depth_nil?(names)
    end

    def is_solo?
      workstation_resource[:solo]
    end

    def load_chef
      super
      if is_solo? && run_as_root?
        require 'chef/application/solo'

        create_chef_additionnal_dir
        @clientapp ||= Chef::Application::Solo.new
      elsif is_solo?
        restart_bootstrap
      else
        extend SelfBootstrap::ChefClient
        load_chef
      end
    end

    def repo_options
      @clientapp.nil? || @clientapp.config.nil? || @clientapp.config.empty? ? super : @clientapp.config
    end

    def clientapp
      @clientapp ||= Chef::Application::Solo.new
      if run_as_root?
        if @clientapp.config.nil? || @clientapp.config.empty?
          @clientapp.config = {} if @clientapp.config.nil?
          repo_options.each do |key, value|
            @clientapp.config[key] = value
          end
        end
      end
      @clientapp
    end

    def chef_client
      clientapp.run(enforce_license: true)
    end

    def serialize_cookbooks_source
      workstation_resource[:cookbooks_source].each_with_object([]) do |cookbook, container|
        cookbookname = cookbook.keys[0]
        source = cookbook[cookbookname][:source]
        container << "cookbook '#{cookbookname}', github: '#{source[:github][:repo]}', branch: 'master'" if source.key?(:github)
      end.join("\n")
    end

    def generate_solo_file
      config_file = ::File.join(workstation_solo_d_dir, project_name + '.rb')
      open(config_file, 'w+') do |f|
        f.puts <<-"EOS"
#{chef_solo_options_encode}
EOS
      end
    end

    def unique_port(port_name)
      @unique_port ||= {
        ssh_port: 2220 - 1,
        http_port: 8880 - 1,
        https_port: 4430 - 1,
      }
      @unique_port[port_name] += 1
      @unique_port[port_name]
    end

    def ssh_port
      unique_port :ssh_port
    end

    def http_port
      unique_port :http_port
    end

    def https_port
      unique_port :https_port
    end

    def render_template(generated_path, source, **variables)
      require_implement_method('render_template', %w(generated_path source action **variables))
    end

    def generate_first_policy(policyname, policygroup)
      policyfile = ::File.join(workstation_policy_dir, policyname)
      policyfilepath = policyfile + '.rb'
      run_opt = { as_system: true, live: true }
      chef(%w(generate policyfile) | [policyfile], as_system: true, live: true)
      open(policyfilepath, 'w') do |f|
        f.puts <<-"EOS"
# Policyfile.rb - Describe how you want Chef Infra Client to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile/

# A name that describes what the system you're building with Chef does.
name 'infra_chef'

# Where to find external cookbooks:
default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list 'infra_chef::default'

# Specify a custom source for a single cookbook:
# cookbook 'example_cookbook', path: '../cookbooks/example_cookbook'

#{serialize_cookbooks_source}
EOS
      end
      if ::File.exist?(policyfilepath)
        chef ['install', policyfilepath], as_system: true, live: true
        base_command 'kitchen', %w(converge), as_system: true, live: true
        chef ['push', policygroup, policyfilepath], as_system: true, live: true
      end
    end

    def generate_kitchen_file
      open(::File.join(get_path(workstation_chef_repo_path), 'kitchen.yml'), 'w') do |f|
        f.puts <<-"EOS"
<%
require 'selfbootstrap'
extend SelfBootstrap
%>
---
provisioner:
  name: chef_zero
  always_update_cookbooks: true
  kitchen_root: <%= workstation_chef_repo_path %>

verifier:
  name: inspec

platforms:
  - name: <%= project_name %>
    driver:
      name: vagrant
      box: bento/ubuntu-20.04
      cache_directory: <%= omnibus_cache_directory %>
      kitchen_cache_directory: <%= kitchen_cache_directory %>
      domain: <%= project_name %>.local
      vm_hostname: <%= project_name %>.local
      network:
      - ["forwarded_port", {guest: 2222, host: <%= ssh_port %>}]
      - ["forwarded_port", {guest: 80, host: <%= http_port %>}]
      - ["forwarded_port", {guest: 443, host: <%= https_port %>}]
      customize:
        memory: 8196
        cpus: 2
        firmware: bios
        hwvirtex: "on"
        vtxvpid: "on"
        vtxux: "on"
        nested-hw-virt: "on"
        cpuhotplug: "on"
        vrde: "on"
        vrdeport: 3390
        autostart-enabled: "on"
suites:
  - name: default
    named_run_list: default
    includes:
    - <%= project_name %>
EOS
      end
    end

    def authenticate_to_chef_infra_server
      load_chef
      debug_worklog 'boostrapped with solo and chef-client'

      # generate_workstation_berksfile
      generate_solo_file
      generate_kitchen_file
      generate_first_policy 'infra_chef', project_name
      chef_client
    end
  end
end

#
# The module you have defined may be extended within the recipe to grant the
# recipe the helper methods you define.
#
# Within your recipe you would write:
#
#     extend SelfBootstrap::WithChefHelpers
#
#     my_helper_method
#
# You may also add this to a single resource within a recipe:
#
#     template '/etc/app.conf' do
#       extend SelfBootstrap::WithChefHelpers
#       variables specific_key: my_helper_method
#     end
#
