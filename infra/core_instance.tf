# Copyright © 2020, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

// Get the latest Oracle Linux image
data "oci_core_images" "images" {
    compartment_id           = local.compartment_ocid
    operating_system         = local.compute_image
    operating_system_version = var.linux_os_version
    shape                    = local.compute_shape

    filter {
        name   = "display_name"
        values = ["^.*Oracle[^G]*$"]
        regex  = true
    }
}

resource "oci_core_instance" "instance_controller" {
    compartment_id      = local.compartment_ocid
    display_name        = format("%s-controller", var.proj_abrv)
    availability_domain = local.availability_domain
    shape               = local.compute_shape
    dynamic "shape_config" {
        for_each = local.is_flexible_shape ? [1] : []
        content {
        baseline_ocpu_utilization = "BASELINE_1_2"
        ocpus                     = 2
        // Memory OCPU * 16GB
        memory_in_gbs             = 2 * 16
        }
    }
    source_details {
        source_type = "image"
        source_id   = data.oci_core_images.images.images[0].id
    }
    agent_config {
        are_all_plugins_disabled = false
        is_management_disabled   = false
        is_monitoring_disabled   = false
        plugins_config  {
        desired_state = "ENABLED"
        name          = "Bastion"
        }
    }
    // If this is ALF, we can't place in the private subnet as need access to the cloud agent/packages
    create_vnic_details {
        subnet_id        = oci_core_subnet.subnet_public.id
        assign_public_ip = true
        nsg_ids          = [oci_core_network_security_group.security_group_controller.id]
    }
    metadata = {
        ssh_authorized_keys = tls_private_key.example_com.public_key_openssh
        user_data           = "${base64encode(data.template_file.userdata.rendered)}"
    }
}