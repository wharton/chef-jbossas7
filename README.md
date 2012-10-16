# wharton-jboss-eap6

## Description

Installs/configures Red Hat JBoss Enterprise Application Platform 6

## Requirements

### Platforms

* RedHat 6.3 (Santiago)

## Attributes

* `node["jboss-eap6"]["jbossas"]["ip"]` - JBoss AS server binding IP, defaults
  to "127.0.0.1"
* `node["jboss-eap6"]["jbossas"]["mgmt-users"]` - array of hashes with username and
  password for users in JBoss AS ManagementRealm, defaults to []
* `node["jboss-eap6"]["jbossas"]["mode"]` - JBoss AS server mode - "domain" or "standalone",
  defaults to "standalone"

## Recipes

* `recipe[wharton-jboss-eap6]` will install and enable JBoss EAP 6

## Usage

Add `recipe[wharton-jboss-eap6]` in your run list.
