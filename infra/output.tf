output "controller_url" {
    value = format("http://%s:8080",oci_core_instance.instance_controller.public_ip)
}

output "ssh_cmd" {
    value = format("ssh -i controller_key opc@%s",oci_core_instance.instance_controller.public_ip)
}