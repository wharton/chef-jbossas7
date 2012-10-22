#
# Cookbook Name:: jbossas7
# Library:: jbossas7
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

class Chef::Recipe::JBossAS7
  def self.add_domain_master(slave)
    master = domain_master(slave)
    slave["jbossas7"]["domain"]["master"]["address"] = master["jbossas7"]["hostname"]
  end

  def self.add_domain_slaves_mgmt_users(master)
    Chef::Log.info("Adding JBoss AS slave mgmt-users for domain authentication")
    domain_slaves(master).each do |slave|
      add_hostname_mgmt_user(master,slave)
    end
  end

  def self.add_hostname_mgmt_user(node,node2)
    node["jbossas7"]["mgmt-users"]["#{node2["jbossas7"]["hostname"]}"] = hostname_mgmt_user(node2)
  end

  def self.create_hostname_mgmt_user(node)
    Chef::Log.info("Creating JBoss AS mgmt-user for domain authentication")
    require 'base64'
    require 'digest'
    require 'securerandom'
    password = SecureRandom.urlsafe_base64(16)
    new_hostname_mgmt_user = {
      "password" => Digest::MD5.hexdigest(password),
      "secret" => Base64.strict_encode64(password)
    }
    node["jbossas7"]["mgmt-users"]["#{node["jbossas7"]["hostname"]}"] = new_hostname_mgmt_user
    new_hostname_mgmt_user
  end

  def self.domain_master(slave)
    Chef::Search::Query.new.search(:node, "chef_environment:#{slave.chef_environment} AND recipes:jbossas7") do |jboss_node|
      return jboss_node if domain_master?(jboss_node) && in_same_domain?(slave,jboss_node)
    end
    Chef::Application.fatal!("Could not find JBoss AS domain master for node")
  end

  def self.domain_master?(node)
    domain_mode?(node) && node["jbossas7"]["domain"]["host_type"] == "master"
  end

  def self.domain_mode?(node)
    node["jbossas7"]["mode"] == "domain"
  end
  
  def self.domain_slave?(node)
    domain_mode?(node) && node["jbossas7"]["domain"]["host_type"] == "slave"
  end

  def self.domain_slaves(master)
    slave_nodes = []
    Chef::Search::Query.new.search(:node, "chef_environment:#{master.chef_environment} AND recipes:jbossas7") do |jboss_node|
      slave_nodes << jboss_node if domain_slave?(jboss_node) && in_same_domain?(master,jboss_node)
    end
    slave_nodes
  end

  def self.has_domain_master?(node)
    domain_slave?(node) && node["jbossas7"]["domain"]["master"]["address"]
  end

  def self.hostname_mgmt_user(node)
    node["jbossas7"]["mgmt-users"]["#{node["jbossas7"]["hostname"]}"]
  end

  def self.in_same_domain?(node,node2)
    node["jbossas7"]["domain"]["name"] == node2["jbossas7"]["domain"]["name"]
  end
end
