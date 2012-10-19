#
# Cookbook Name:: wharton-jboss-eap6
# Recipe:: default
#
# Copyright 2012
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

mode_config_dir = "/etc/jbossas/#{node["jboss-eap6"]["jbossas"]["mode"]}"

node["jboss-eap6"]["jbossas"]["packages"].each do |pkg|
  package pkg
end

service "jbossas" do
  supports :status => true, :restart => true, :reload => true
  action :enable
end

template "/etc/jbossas/jbossas.conf" do
  source "jbossas.conf.erb"
  owner "jboss"
  group "jboss"
  mode "0644"
  notifies :restart, resources(:service => "jbossas"), :delayed
end

if node["jboss-eap6"]["jbossas"]["mode"] == "domain" && node["jboss-eap6"]["jbossas"]["domain"]["host_type"] == "slave"
  hostname_mgmt_user = node["jboss-eap6"]["jbossas"]["mgmt-users"]["#{node["jboss-eap6"]["jbossas"]["hostname"]}"]
  unless hostname_mgmt_user
    Chef::Log.info("Creating JBoss AS mgmt-user for domain authentication")
    require 'base64'
    require 'digest'
    require 'securerandom'
    password = SecureRandom.urlsafe_base64(16)
    hostname_mgmt_user = {
      "password" => Digest::MD5.hexdigest(password),
      "secret" => Base64.strict_encode64(password)
    }
    node["jboss-eap6"]["jbossas"]["mgmt-users"]["#{node["jboss-eap6"]["jbossas"]["hostname"]}"] = hostname_mgmt_user
  end

  template "#{mode_config_dir}/host-slave.xml" do
    source "host-slave-initial.xml.erb"
    owner "jboss"
    group "jboss"
    mode "0644"
    variables :secret => hostname_mgmt_user["secret"]
    only_if "grep -q 'c2xhdmVfdXNlcl9wYXNzd29yZA==' /etc/jbossas/domain/host-slave.xml"
    notifies :restart, resources(:service => "jbossas"), :delayed
  end
end

if node["jboss-eap6"]["jbossas"]["mode"] == "domain" && node["jboss-eap6"]["jbossas"]["domain"]["host_type"] == "master"
  search(:node, "chef_environment:#{node.chef_environment} AND recipes:wharton-jboss-eap6") do |jboss_node|
    if jboss_node["jboss-eap6"]["jbossas"]["domain"]["host_type"] = "slave"
      jboss_node_hostname = jboss_node["jboss-eap6"]["jbossas"]["hostname"]
      node["jboss-eap6"]["jbossas"]["mgmt-users"]["#{jboss_node_hostname}"] = jboss_node["jboss-eap6"]["jbossas"]["mgmt-users"]["#{jboss_node_hostname}"]
    end
  end
end

template "#{mode_config_dir}/mgmt-users.properties" do
  source "mgmt-users.properties.erb"
  owner "jboss"
  group "jboss"
  mode "0644"
end
