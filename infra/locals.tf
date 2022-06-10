# Dictionary Locals
locals {
  compute_flexible_shapes = [
    "VM.Standard.E3.Flex",
    "VM.Standard.E4.Flex",
    "VM.Standard.A1.Flex",
    "VM.Optimized3.Flex"
  ]
}

locals {
    compartment_ocid  = var.compartment_ocid != "" ? var.compartment_ocid : var.tenancy_ocid
    compute_image     = "Oracle Linux"
    compute_shape     = "VM.Standard.E3.Flex"
    is_flexible_shape = contains(local.compute_flexible_shapes, local.compute_shape)
    jenkins_password  = var.jenkins_password != "" ? var.jenkins_password : random_password.admin_password.result
}