# -*- encoding: utf-8 -*-
#
# Author:: Dan Ryan (<dan@appliedawesome.com>)
#
# Copyright (c) 2013, Dan Ryan
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require 'chef/knife/vm_base'
require 'knife/vm/vm'

class Chef
  class Knife
    class VmServerCreate < Knife

      include Knife::VmBase

      deps do
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
      end

      banner "knife vm server create NAME (options)"

      # option :hostname,
      #   :short => "-H HOST",
      #   :long => "--hostname HOST",
      #   :description => "Hostname of VM",
      #   :proc => Proc.new { |key| Chef::Config[:knife][:hostname] = key }

      option :box,
        :long => "--box BOX",
        :description => "Vagrant box name",
        :proc => Proc.new { |key| Chef::Config[:knife][:box] = key }

      option :box_url,
        :long => "--box-url BOX",
        :description => "Vagrant box URL",
        :proc => Proc.new { |key| Chef::Config[:knife][:box_url] = key }

      option :chef_node_name,
        :short => "-N NAME",
        :long => "--node-name NAME",
        :description => "The Chef node name for your new node",
        :proc => Proc.new { |key| Chef::Config[:knife][:chef_node_name] = key }

      option :ssh_user,
        :short => "-x USERNAME",
        :long => "--ssh-user USERNAME",
        :description => "The ssh username",
        :default => "vagrant"

      option :ssh_password,
        :short => "-P PASSWORD",
        :long => "--ssh-password PASSWORD",
        :description => "The ssh password",
        :default => "vagrant"

      option :identity_file,
        :short => "-i IDENTITY_FILE",
        :long => "--identity-file IDENTITY_FILE",
        :description => "The SSH identity file used for authentication"

      option :prerelease,
        :long => "--prerelease",
        :description => "Install the pre-release chef gems"

      option :bootstrap_version,
        :long => "--bootstrap-version VERSION",
        :description => "The version of Chef to install",
        :proc => Proc.new { |v| Chef::Config[:knife][:bootstrap_version] = v }

      option :distro,
        :short => "-d DISTRO",
        :long => "--distro DISTRO",
        :description => "Bootstrap a distro using a template; default is 'chef-full'",
        :proc => Proc.new { |d| Chef::Config[:knife][:distro] = d }

      option :template_file,
        :long => "--template-file TEMPLATE",
        :description => "Full path to location of template to use",
        :proc => Proc.new { |t| Chef::Config[:knife][:template_file] = t },
        :default => false

      option :run_list,
        :short => "-r RUN_LIST",
        :long => "--run-list RUN_LIST",
        :description => "Comma separated list of roles/recipes to apply",
        :proc => lambda { |o| o.split(/[\s,]+/) }

      option :json_attributes,
        :short => "-j JSON",
        :long => "--json-attributes JSON",
        :description => "A JSON string to be added to the first run of chef-client",
        :proc => lambda { |o| JSON.parse(o) }

      option :hint,
        :long => "--hint HINT_NAME[=HINT_FILE]",
        :description => "Specify Ohai Hint to be set on the bootstrap target.  Use multiple --hint options to specify multiple hints.",
        :proc => Proc.new { |h|
          Chef::Config[:knife][:hints] ||= {}
          name, path = h.split("=")
          Chef::Config[:knife][:hints][name] = path ? JSON.parse(::File.read(path)) : Hash.new
        }

      def run
        unless config[:chef_node_name] || name_args.size >= 1
          ui.fatal "You did not provide a valid 'Node Name' value."
          show_usage
          exit 1
        end


        node_bootstrap.run
      end

      def node_bootstrap(ip)
        bootstrap = Chef::Knife::Bootstrap.new
        bootstrap.name_args = [ip]
        bootstrap.config[:run_list] = locate_config_value(:run_list) || []
        bootstrap.config[:ssh_user] = config[:ssh_user]
        bootstrap.config[:ssh_port] = config[:ssh_port]
        bootstrap.config[:identity_file] = config[:identity_file]
        bootstrap.config[:chef_node_name] = locate_config_value(:chef_node_name)
        bootstrap.config[:prerelease] = config[:prerelease]
        bootstrap.config[:bootstrap_version] = locate_config_value(:bootstrap_version)
        bootstrap.config[:first_boot_attributes] = locate_config_value(:json_attributes) || {}
        bootstrap.config[:distro] = locate_config_value(:distro) || "chef-full"
        bootstrap.config[:use_sudo] = true unless config[:ssh_user] == 'root'
        bootstrap.config[:template_file] = locate_config_value(:template_file)
        bootstrap.config[:environment] = config[:environment]
        bootstrap
      end

    end
  end
end
