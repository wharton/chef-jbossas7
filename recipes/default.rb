
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
  action [ :enable, :start ]
end
