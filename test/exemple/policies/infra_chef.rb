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

default_source :chef_repo, '/usr/local/chef/repo/jimbodragon/cookbooks' do |market|
  market.preferred_for 'infra_chef', 'chef_workstation_initialize', 'chef-git-server', 'chefserver', 'virtualbox'
end
