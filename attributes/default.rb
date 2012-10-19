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

default["jboss-eap6"]["jbossas"]["hostname"]   = node["hostname"].gsub(/[-_]/,"")
default["jboss-eap6"]["jbossas"]["mgmt-users"] = []
default["jboss-eap6"]["jbossas"]["mode"]       = "standalone"
default["jboss-eap6"]["jbossas"]["packages"]   = %w{
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

default["jboss-eap6"]["jbossas"]["bind"]["public"]     = "127.0.0.1"
default["jboss-eap6"]["jbossas"]["bind"]["management"] = "127.0.0.1"
default["jboss-eap6"]["jbossas"]["bind"]["unsecure"]   = "127.0.0.1"

default["jboss-eap6"]["jbossas"]["domain"]["host_type"]         = "master"
default["jboss-eap6"]["jbossas"]["domain"]["master"]["address"] = nil
default["jboss-eap6"]["jbossas"]["domain"]["master"]["port"]    = 9999
