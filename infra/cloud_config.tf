# Copyright © 2020, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
data template_file "userdata" {
  template = file("${path.module}/templates/controller-cloud-config.yaml")
  vars = {
      jenkins_password  = local.password
      jenkins_plugins   = join(" ", var.jenkins_plugins)
      database_service  = format("%sDB_HIGH", upper(var.proj_abrv))
      connection_string = element([for i, v in oci_database_autonomous_database.autonomous_database.connection_strings[0].profiles : 
                            v.value if v.consumer_group == "HIGH" && v.tls_authentication == "SERVER"],0)
  }
}