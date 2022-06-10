# Copyright © 2020, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "random_password" "autonomous_database_password" {
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

resource "oci_database_autonomous_database" "autonomous_database" {
  admin_password           = random_password.autonomous_database_password.result
  compartment_id           = local.compartment_ocid
  db_name                  = format("%sDB", upper(var.proj_abrv))
  cpu_core_count           = 1
  data_storage_size_in_tbs = 1
  db_version               = "19c"
  db_workload              = "OLTP"
  display_name             = format("%sDB", upper(var.proj_abrv))
  is_free_tier             = false
  is_auto_scaling_enabled  = false
  license_model            = "BRING_YOUR_OWN_LICENSE"
  whitelisted_ips          = []
  nsg_ids                  = []
  lifecycle {
    ignore_changes = all
  }
}