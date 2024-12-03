#!/opt/chef-workstation/embedded/bin/ruby

$LOAD_PATH.unshift File.join(File.dirname(File.dirname(__dir__)), %w(lib))

::Dir.chdir __dir__

::File.delete 'bootstrapping_in_progress' if ::File.exist? 'bootstrapping_in_progress'

require 'selfbootstrap'
SelfBootstrap.bootstrap
