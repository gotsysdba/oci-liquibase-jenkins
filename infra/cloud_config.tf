# Copyright © 2020, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
resource "random_password" "admin_password" {
  length           = 16
  min_numeric      = 1
  min_lower        = 1
  min_upper        = 1
  min_special      = 1
  override_special = "_#"
  keepers = {
    uuid = "uuid()"
  }
}

data template_file "userdata" {
  template = file("${path.module}/templates/controller-cloud-config.yaml")
  vars = {
      jenkins_password = local.jenkins_password
      jenkins_plugins  = join(" ", var.jenkins_plugins)
  }
}