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

packages = %w{
	jbossas-appclient
  jbossas-bundles
  jbossas-core
  jbossas-domain
  jbossas-hornetq-native
  jbossas-jbossweb-native
  jbossas-modules-eap
  jbossas-product-eap
  jbossas-standalone
  jbossas-welcome-content-eap
}

packages.each do |pkg|
  package pkg
end

service "jbossas" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable ]
end

template "/etc/jbossas/jbossas.conf" do
  source "jbossas.conf.erb"
  owner "jboss"
  group "jboss"
  mode "0644"
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

service "jbossas" do
  action [ :start ]
end
