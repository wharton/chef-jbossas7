#
# Cookbook Name:: jbossas7
# Recipe:: configuration
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

JBossAS7.add_domain_master(node) unless JBossAS7.has_domain_master?(node)

template "#{node["jbossas7"]["home"]}/jbossas.conf" do
  source "jbossas.conf.erb"
  owner "jboss"
  group "jboss"
  mode "0644"
  notifies :restart, resources(:service => "jbossas"), :delayed
end

if JBossAS7.master?(node)
  template "#{node["jbossas7"]["home"]}/#{node["jbossas7"]["mode"]}/host-master.xml" do
    source "host-master-initial.xml.erb"
    owner "jboss"
    group "jboss"
    mode "0644"
    only_if "grep -q 'name=\"master\"' #{node["jbossas7"]["home"]}/#{node["jbossas7"]["mode"]}/host-master.xml"
    notifies :restart, resources(:service => "jbossas"), :delayed
  end
end

if JBossAS7.domain_slave?(node)
  JBossAS7.create_hostname_mgmt_user(node) unless JBossAS7.hostname_mgmt_user(node)

  template "#{node["jbossas7"]["home"]}/#{node["jbossas7"]["mode"]}/host-slave.xml" do
    source "host-slave-initial.xml.erb"
    owner "jboss"
    group "jboss"
    mode "0644"
    variables :secret => JBossAS7.hostname_mgmt_user(node)["secret"]
    only_if "grep -q 'c2xhdmVfdXNlcl9wYXNzd29yZA==' #{node["jbossas7"]["home"]}/#{node["jbossas7"]["mode"]}/host-slave.xml"
    notifies :restart, resources(:service => "jbossas"), :delayed
  end
end

JBossAS7.add_domain_slaves_mgmt_users(node) if JBossAS7.domain_master?(node)

template "#{node["jbossas7"]["home"]}/#{node["jbossas7"]["mode"]}/mgmt-users.properties" do
  source "mgmt-users.properties.erb"
  owner "jboss"
  group "jboss"
  mode "0644"
end
