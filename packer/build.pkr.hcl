build {
  name    = "test-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  # provisioner "shell" {
  #   environment_vars = [
  #     "FOO=hello world",
  #   ]
  #   inline = [
  #     "echo Installing Nginx",
  #     "sleep 30",
  #     "sudo apt-get update",
  #     "sudo apt-get install -y nginx awscli git",
  #   ]
  # }
  # provisioner "file" {
  #   source      = "./db/"
  #   destination = "/tmp/"
  # }

  provisioner "ansible" {
    playbook_file = "../ansible/db_provision.yml"
    user          = "ubuntu"
    # Optional: If your roles are in a specific directory not relative to the playbook
    roles_path = "../ansible/roles"
  }

  post-processor "manifest" {
    output = "manifest.json"
  }

}
