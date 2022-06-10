# Copyright © 2020, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_vcn" "vcn" {
  compartment_id = local.compartment_ocid
  display_name   = format("%s-vcn", var.proj_abrv)
  cidr_block     = var.vcn_cidr
  is_ipv6enabled = var.vcn_is_ipv6enabled
  dns_label      = var.proj_abrv
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = local.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = format("%s-internet-gateway", var.proj_abrv)
}

resource "oci_core_route_table" "route_table_internet_gw" {
    compartment_id = local.compartment_ocid
    vcn_id         = oci_core_vcn.vcn.id
    display_name   = format("%s-route-table-internet-gw", var.proj_abrv)
    route_rules {
        destination       = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
        network_entity_id = oci_core_internet_gateway.internet_gateway.id
    }
}

resource "oci_core_subnet" "subnet_public" {
    compartment_id             = local.compartment_ocid
    vcn_id                     = oci_core_vcn.vcn.id
    display_name               = format("%s-subnet-public", var.proj_abrv)
    cidr_block                 = var.public_subnet_cidr
    route_table_id             = oci_core_route_table.route_table_internet_gw.id
    dhcp_options_id            = oci_core_vcn.vcn.default_dhcp_options_id
    dns_label                  = "publ"
    prohibit_public_ip_on_vnic = false
}

resource "oci_core_nat_gateway" "nat_gateway" {
    compartment_id = local.compartment_ocid
    vcn_id         = oci_core_vcn.vcn.id
    display_name   = format("%s-nat-gateway", var.proj_abrv)
}

resource "oci_core_route_table" "route_table_nat_gw" {
    compartment_id = local.compartment_ocid
    vcn_id         = oci_core_vcn.vcn.id
    display_name   = format("%s-route-table-nat-gw", var.proj_abrv)
    route_rules {
        destination       = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
        network_entity_id = oci_core_nat_gateway.nat_gateway.id
    }
}

resource "oci_core_subnet" "subnet_private" {
    compartment_id             = local.compartment_ocid
    vcn_id                     = oci_core_vcn.vcn.id
    display_name               = format("%s-subnet-private", var.proj_abrv)
    cidr_block                 = var.private_subnet_cidr
    route_table_id             = oci_core_route_table.route_table_nat_gw.id
    dhcp_options_id            = oci_core_vcn.vcn.default_dhcp_options_id
    dns_label                  = "priv"
    prohibit_public_ip_on_vnic = true
}