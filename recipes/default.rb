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
  template "/etc/jbossas/domain/host-slave.xml" do
    source "host-slave-initial.xml.erb"
    owner "jboss"
    group "jboss"
    mode "0644"
    variables :secret => node["jboss-eap6"]["jbossas"]["mgmt-users"][0]["secret"]
    only_if "grep -q 'c2xhdmVfdXNlcl9wYXNzd29yZA==' /etc/jbossas/domain/host-slave.xml"
    notifies :restart, resources(:service => "jbossas"), :delayed
  end
end

template "/etc/jbossas/domain/mgmt-users.properties" do
  source "mgmt-users.properties.erb"
  owner "jboss"
  group "jboss"
  mode "0644"
end

template "/etc/jbossas/standalone/mgmt-users.properties" do
  source "mgmt-users.properties.erb"
  owner "jboss"
  group "jboss"
  mode "0644"
end
