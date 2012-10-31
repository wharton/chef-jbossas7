#
# Cookbook Name:: jbossas7
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

default["jbossas7"]["home"]       = "/usr/share/jbossas"
default["jbossas7"]["hostname"]   = node["hostname"].gsub(/[-_]/,"")
default["jbossas7"]["mgmt-users"] = []
default["jbossas7"]["mode"]       = "standalone"

default["jbossas7"]["bind"]["public"]     = "127.0.0.1"
default["jbossas7"]["bind"]["management"] = "127.0.0.1"
default["jbossas7"]["bind"]["unsecure"]   = "127.0.0.1"

default["jbossas7"]["domain"]["host_type"]         = "master"
default["jbossas7"]["domain"]["JAVA_OPTS"]         = %w{
  -Xms64m
  -Xmx512m
  -XX:MaxPermSize=256m
  -Djava.net.preferIPv4Stack=true
  -Dorg.jboss.resolver.warning=true
  -Dsun.rmi.dgc.client.gcInterval=3600000
  -Dsun.rmi.dgc.server.gcInterval=3600000
}
default["jbossas7"]["domain"]["master"]["address"] = nil
default["jbossas7"]["domain"]["master"]["port"]    = 9999
default["jbossas7"]["domain"]["name"]              = nil

default["jbossas7"]["eap6"]["packages"] = %w{
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

default["jbossas7"]["standalone"]["JAVA_OPTS"]  = %w{
  -Xms1303m
  -Xmx1303m
  -XX:MaxPermSize=256m
  -Djava.net.preferIPv4Stack=true
  -Dorg.jboss.resolver.warning=true
  -Dsun.rmi.dgc.client.gcInterval=3600000
  -Dsun.rmi.dgc.server.gcInterval=3600000
}
