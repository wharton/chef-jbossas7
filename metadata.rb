name              "jbossas7"
maintainer        "The Wharton School - The University of Pennsylvania"
maintainer_email  "bflad@wharton.upenn.edu"
license           "Apache 2.0"
description       "Installs/configures JBoss AS 7."
version           "0.0.1"
recipe            "jbossas7", "Base JBoss AS 7 installation and configuration."
recipe            "jbossas7::configuration", "Attribute-driven configuration."
recipe            "jbossas7::eap6", "Red Hat JBoss EAP6 installation and configuration (includes AS 7)."

%w{ redhat }.each do |os|
  supports os
end
