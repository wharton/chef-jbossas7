maintainer        "The Wharton School - The University of Pennsylvania"
maintainer_email  "bflad@wharton.upenn.edu"
license           "Apache 2.0"
description       "Installs/configures JBoss Enterprise Application Platform 6."
version           "0.0.1"
recipe            "wharton-jboss-eap6", "Base JBoss EAP6 installation."

%w{ redhat }.each do |os|
  supports os
end
