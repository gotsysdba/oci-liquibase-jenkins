# Copyright © 2020, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
data template_file "userdata" {
  template = file("${path.module}/templates/controller-cloud-config.yaml")
  vars = {
      jenkins_password = local.password
      jenkins_plugins  = join(" ", var.jenkins_plugins)
      wallet_file      = format("/tmp/%sDB_wallet.zip", upper(var.proj_abrv))
  }
}