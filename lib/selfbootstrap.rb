#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

require_relative 'selfbootstrap/withlogger'

module ChefWorkstationInitialize
  module SelfBootstrap
    class ::Array
      def deep_merge(second)
        if second.is_a?(Array)
          self | v2
        else
          self
        end
      end
    end

    class ::Hash
      def deep_merge(second)
        merger = proc do |key, v1, v2|
          if v1.is_a?(Hash) && v2.is_a?(Hash)
            v1.deep_merge(v2)
          elsif v1.is_a?(Array) && v2.is_a?(Array)
            v1 | v2
          elsif [:undefined, nil, :nil].include?(v2)
            v1
          else
            v2
          end
        end
        merge(second, &merger)
      end

      def stringify_keys!
        stringify_keys(self)
      end

      def stringify_keys(otherhash)
        if otherhash.is_a? Hash
          otherhash.map do |k, v|
            new_v = v.is_a?(Hash) ? stringify_keys(v) : v
            [k.to_s, new_v]
          end.to_h
        else
          otherhash
        end
      end

      def symbolify_keys!
        symbolify_keys(self)
      end

      def symbolify_keys(otherhash)
        if otherhash.is_a? Hash
          otherhash.map do |k, v|
            new_v = v.is_a?(Hash) ? symbolify_keys(v) : v
            [k.to_sym, new_v]
          end.to_h
        else
          otherhash
        end
      end

      def depth_nil?(*names)
        return false if names.empty?
        return true if self[names.pop].nil?

        depth_nil?(names)
      end

      def ivars_excluded_from_hashify
        @ivars_excluded_from_hash ||= []
      end

      def hashify
        hash = {}
        excluded_ivars = ivars_excluded_from_hashify

        # Iterate over all the instance variables and store their
        # names and values in a hash
        each do |key, value|
          next if excluded_ivars.include? key.to_s
          value = value.map(&:hashify) if value.is_a? Array
          value = value.hashify if value.is_a? Hash

          hash[key.to_s] = value.to_s
        end
      end

      def yaml_output
        yaml_convert = ''
        to_yaml.each_line do |line|
          unless line.include? '---'
            yaml_convert += line
          end
        end
        yaml_convert
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
