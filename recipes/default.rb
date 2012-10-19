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
JBossEAP6::JBossAS.add_domain_master(node) unless JBossEAP6::JBossAS.has_domain_master?(node)

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

if JBossEAP6::JBossAS.domain_slave?(node)
  JBossEAP6::JBossAS.create_hostname_mgmt_user(node) unless JBossEAP6::JBossAS.hostname_mgmt_user(node)

  template "#{mode_config_dir}/host-slave.xml" do
    source "host-slave-initial.xml.erb"
    owner "jboss"
    group "jboss"
    mode "0644"
    variables :secret => JBossEAP6::JBossAS.hostname_mgmt_user(node)["secret"]
    only_if "grep -q 'c2xhdmVfdXNlcl9wYXNzd29yZA==' /etc/jbossas/domain/host-slave.xml"
    notifies :restart, resources(:service => "jbossas"), :delayed
  end
end

JBossEAP6::JBossAS.add_domain_slaves_mgmt_users(node) if JBossEAP6::JBossAS.domain_master?(node)

template "#{mode_config_dir}/mgmt-users.properties" do
  source "mgmt-users.properties.erb"
  owner "jboss"
  group "jboss"
  mode "0644"
end
