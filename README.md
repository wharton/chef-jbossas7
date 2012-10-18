# wharton-jboss-eap6

## Description

Installs/configures Red Hat JBoss Enterprise Application Platform 6

## Requirements

### Platforms

* RedHat 6.3 (Santiago)

## Attributes

* `node["jboss-eap6"]["jbossas"]["mgmt-users"]` - array of hashes with username 
  and password for users in JBoss AS ManagementRealm, defaults to []
* `node["jboss-eap6"]["jbossas"]["mode"]` - JBoss AS server mode - "domain" or
  "standalone", defaults to "standalone"

* `node["jboss-eap6"]["jbossas"]["bind"]["management"]` - JBoss AS server
  binding IP for management interface, defaults to "127.0.0.1"
* `node["jboss-eap6"]["jbossas"]["bind"]["public"]` - JBoss AS server binding IP
  for public interface, defaults to "127.0.0.1"
* `node["jboss-eap6"]["jbossas"]["bind"]["unsecure"]` - JBoss AS server binding
  IP for unsecure interface, defaults to "127.0.0.1"

* `node["jboss-eap6"]["jbossas"]["domain"]["host_type"]` - set host as "master"
  or "slave" in domain, defaults to "master"
* `node["jboss-eap6"]["jbossas"]["domain"]["master"]["address"]` - remote
  domain master address, defaults to ""
* `node["jboss-eap6"]["jbossas"]["domain"]["master"]["port"]` - remote
  domain master port, defaults to 9999

## Recipes

* `recipe[wharton-jboss-eap6]` will install and enable JBoss EAP 6

## Usage

* Configure attributes as necessary, you'll probably want to configure most of
  them unless its a test standalone instance (for Vagrant, etc.) - examples
  below
* Add `recipe[wharton-jboss-eap6]` in your run list.

### Public Standalone Instance

Example attributes with localhost management interface:
    "jboss-eap6" => {
      "jbossas" => {
        "bind" => {
          "public" => "0.0.0.0"
        },
        "mgmt-users" => [
          { "username" => "admin", "password" => "add-user.sh-hash-of-password" }
        ]
      }
    }

### Domain Master Instance

Example attributes with remotely accessible management interface:
    "jboss-eap6" => {
      "jbossas" => {
        "bind" => {
          "management" => "0.0.0.0"
        },
        "mgmt-users" => [
          { "username" => "admin", "password" => "add-user.sh-hash-of-password" }
        ],
        "mode" => "domain"
      }
    }

### Domain Slave Instance

Example attributes with remotely accessible management (required) and public
interfaces:
    "jboss-eap6" => {
      "jbossas" => {
        "bind" => {
          "management" => "0.0.0.0",
          "public" => "0.0.0.0"
        },
        "domain" => {
          "host_type" => "slave",
          "master" => { "address" => "X.X.X.X" }
        }
        "mgmt-users" => [
          { "username" => "admin", "password" => "add-user.sh-hash-of-password" }
        ],
        "mode" => "domain"
      }
    }

## License and Author
      
Author:: Brian Flad (<bflad@wharton.upenn.edu>)

Copyright:: 2012

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
