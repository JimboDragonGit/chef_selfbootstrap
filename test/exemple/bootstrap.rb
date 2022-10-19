#!/usr/bin/env ruby

puts $LOAD_PATH.unshift File.join(File.dirname(File.dirname(__dir__)), %w(lib))

::Dir.chdir __dir__

require 'selfbootstrap'
ChefWorkstationInitialize::SelfBootstrap.bootstrap
