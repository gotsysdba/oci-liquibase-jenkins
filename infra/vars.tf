# Copyright © 2020, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

// Basic Hidden
variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "region" {}

// Extra Hidden
variable "user_ocid" {
  default = ""
}
variable "fingerprint" {
  default = ""
}
variable "private_key_path" {
  default = ""
}

// General Configuration
variable "proj_abrv" {
  default = "jenkins"
}

// Jenkins and ADB Password
variable "password" {
  default     = ""
}

// Computes
variable "linux_os_version" {
    default = "8"
}

variable "compute_user" {
    default = "opc"
}

//LBaaS Shape
variable "flex_lb_min_shape" {
  default = 10
}

variable "flex_lb_max_shape" {
  default = 1250
}

// VCN Configurations Variables
variable "vcn_cidr" {
  default = "10.0.0.0/28"
}

variable "vcn_is_ipv6enabled" {
  default = false
}

variable "public_subnet_cidr" {
  description = "Usable Range: 10.0.0.1 - 10.0.0.6"
  default     = "10.0.0.0/29"
}

variable "private_subnet_cidr" {
  description = "Usable Range: 10.0.0.9 - 10.0.0.14"
  default     = "10.0.0.8/29"
}

variable "enable_lb_logging" {
  default = "false"
}

variable "jenkins_plugins" {
  type        = list(any)
  description = "A list of Jenkins plugins to install, use short names. "
  default     = ["git","github","workflow-aggregator","github-branch-source"]
}