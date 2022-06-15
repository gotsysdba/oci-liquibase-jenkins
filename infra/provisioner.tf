resource "null_resource" "upload_wallet" {
  provisioner "file" {
    connection {
      type                = "ssh"
      agent               = false
      user                = var.compute_user
      host                = oci_core_instance.instance_controller.public_ip
      private_key         = tls_private_key.example_com.private_key_openssh
    }
    source      = local_file.database_wallet_file.filename
    destination = format("/tmp/%sDB_wallet.zip", upper(var.proj_abrv))
  }
}