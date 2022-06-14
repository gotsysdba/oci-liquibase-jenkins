// Security Group for controller
resource "oci_core_network_security_group" "security_group_controller" {
    compartment_id = local.compartment_ocid
    vcn_id         = oci_core_vcn.vcn.id
    display_name   = format("%s-security-group-controller", var.proj_abrv)
}
// Security Group for controller - EGRESS
resource "oci_core_network_security_group_security_rule" "security_group_controller_egress_grp" {
    network_security_group_id = oci_core_network_security_group.security_group_controller.id
    direction                 = "EGRESS"
    protocol                  = "6"
    destination               = oci_core_network_security_group.security_group_controller.id
    destination_type          = "NETWORK_SECURITY_GROUP"
}
resource "oci_core_network_security_group_security_rule" "security_group_controller_egress" {
    network_security_group_id = oci_core_network_security_group.security_group_controller.id
    direction                 = "EGRESS"
    protocol                  = "6"
    destination               = "0.0.0.0/0"
    destination_type          = "CIDR_BLOCK"
}
// Security Group for controller - INGRESS
resource "oci_core_network_security_group_security_rule" "security_group_controller_ingress_TCP8080" {
    network_security_group_id = oci_core_network_security_group.security_group_controller.id
    direction                 = "INGRESS"
    protocol                  = "6"
    source                    = "0.0.0.0/0"
    //source                    = var.public_subnet_cidr
    source_type               = "CIDR_BLOCK"
    tcp_options {
        destination_port_range {
        max = 8080
        min = 8080
        }
    }
}

# // Security Group for ADB
# resource "oci_core_network_security_group" "security_group_adb" {
#     compartment_id = local.compartment_ocid
#     vcn_id         = oci_core_vcn.vcn.id
#     display_name   = format("%s-security-group-adb", var.proj_abrv)
# }
# // Security Group for ADB - EGRESS
# resource "oci_core_network_security_group_security_rule" "security_group_adb_egress_grp" {
#     network_security_group_id = oci_core_network_security_group.security_group_adb.id
#     direction                 = "EGRESS"
#     protocol                  = "6"
#     destination               = oci_core_network_security_group.security_group_adb.id
#     destination_type          = "NETWORK_SECURITY_GROUP"
# }
# resource "oci_core_network_security_group_security_rule" "security_group_adb_egress" {
#     network_security_group_id = oci_core_network_security_group.security_group_adb.id
#     direction                 = "EGRESS"
#     protocol                  = "6"
#     destination               = "0.0.0.0/0"
#     destination_type          = "CIDR_BLOCK"
# }
# // Security Group for ADB - INGRESS
# resource "oci_core_network_security_group_security_rule" "security_group_adb_ingress" {
#     network_security_group_id = oci_core_network_security_group.security_group_adb.id
#     direction                 = "INGRESS"
#     protocol                  = "6"
#     source                    = "0.0.0.0/0"
#     source_type               = "CIDR_BLOCK"
#     tcp_options {
#         destination_port_range {
#         max = 1522
#         min = 1522
#         }
#     }
# }
