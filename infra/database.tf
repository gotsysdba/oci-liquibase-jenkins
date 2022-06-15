# Copyright © 2020, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_database_autonomous_database" "autonomous_database" {
    admin_password              = random_password.password.result
    compartment_id              = local.compartment_ocid
    db_name                     = format("%sDB", upper(var.proj_abrv))
    cpu_core_count              = 1
    data_storage_size_in_tbs    = 1
    db_version                  = "19c"
    db_workload                 = "OLTP"
    display_name                = format("%sDB", upper(var.proj_abrv))
    is_free_tier                = var.is_paid ? false : true
    is_auto_scaling_enabled     = false
    license_model               = var.is_paid ? var.adb_license_model : "LICENSE_INCLUDED"
    whitelisted_ips             = [ oci_core_instance.instance_controller.public_ip ]
    is_mtls_connection_required = true
    nsg_ids                     = []
    lifecycle {
        ignore_changes = all
    }
}

resource "oci_database_autonomous_database_wallet" "database_wallet" {
  autonomous_database_id = oci_database_autonomous_database.autonomous_database.id
  password               = random_password.password.result
  base64_encode_content  = "true"
}

resource "local_file" "database_wallet_file" {
  content_base64 = oci_database_autonomous_database_wallet.database_wallet.content
  filename       = format("../wallet/%sDB_wallet.zip", upper(var.proj_abrv))
}