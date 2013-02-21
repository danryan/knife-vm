require 'chef/knife'

class Chef
  class Knife
    module VmBase

      def self.included(base)
        base.class_eval do
          deps do
            require 'chef/json_compat'
          end
        end
      end

      def locate_config_value(key)
        key = key.to_sym
        config[key] || Chef::Config[:knife][key]
      end

    end
  end
end
