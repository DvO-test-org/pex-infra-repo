# Packer

## JSON and HCL

Configuration can be defined in two formats: `json` and `hcl2`.

The content in both formats will differ:
- For **HCL** there will be `packer`, `source`, `build` blocks
- For **JSON** - `variables`, `builders` and in the latter - `provisioners`

## Provisioners

### Ansible Provisioner Example

```json
"provisioners": [
    {
        "type": "ansible",
        "playbook_file": "ansible/playbooks/packer_app.yml",
        "user": "appuser",
        "extra_arguments": ["--tags","ruby"],
        "ansible_env_vars": ["ANSIBLE_ROLES_PATH={{ pwd }}/ansible/roles"]
    }
]
```

```hcl
build {
  name    = "test-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "echo Installing Nginx",
      "sleep 30",
      "sudo apt-getb update",
      "sudo apt-get install -y nginx awscli git",
    ]
  }

  provisioner "ansible" {
    playbook_file = "../ansible/db_provision.yml"
    user          = "ubuntu"
    # Optional: If your roles are in a specific directory not relative to the playbook
    # roles_path = "../ansible/roles"
  }

}
```

## Running Packer

### JSON Format

```bash
packer build -var-file=variables.json nginx-aws.json
packer build -only=basis.amazon-ebs.template .
packer build -only=db.amazon-ebs.template .
```

### HCL2 format

```bash
packer init .
packer build .
```

## Links

### AWS Resources
- [Using Packer to Create an AMI](https://www.pluralsight.com/cloud-guru/labs/aws/using-packer-to-create-an-ami)
- [Amazon EBS Builder](https://developer.hashicorp.com/packer/plugins/builders/amazon/ebs)

### GCP Resources
- [Google Compute Builder](https://www.packer.io/plugins/builders/googlecompute)
- [User Variables Documentation](https://www.packer.io/docs/templates/legacy_json_templates/user-variables)

### Miscellaneous
- [Legacy JSON Templates - User Variables](https://developer.hashicorp.com/packer/docs/templates/legacy_json_templates/user-variables)