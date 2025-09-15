# pex-infra-repo
Infra repo



## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws provider](#requirement\_aws) | ~> 6.0 |

### Local run

To run locally:  

clone repository, switch to environment directory (currently - `dev`):  
```
cd terraform/dev
```
initialize terraform:  
```
terraform init
```
review planned changes:  
```
terraform plan
```
if everythong ok, apply infrastructure code:  
```
terraform apply
```

### Project layout

Terraform code is located in `terraform/` directory:

```
terraform
├── core
│   └── tf_backend
│       ├── backend_bucket.tf
│       └── provider.tf
└── dev
    ├── backend.tf
    ├── db_maria.tf
    ├── iam.tf
    ├── main.tf
    ├── outputs.tf
    ├── provider.tf
    ├── s3.tf
    ├── sg.tf
    ├── templates
    │   ├── deploy_app.sh
    │   └── deploy_db.sh
    ├── terraform.tfvars
    ├── variables.tf
    ├── versions.tf
    └── vpc.tf
```

`terraform/core/` dir contains code for creation of s3 bucket for terraform state backend  


Actual infrastructure code lives in `terraform/dev` directory.   

Resources:  
`VPC` with 2 private and 2 public subnets in 2 AZs with managed NAT gateway.  

2 EC2 instances:  
  `web` - sample web app, placed in public subnet  
  `bastion` - bastion server, the only entrypoint from the internet.  

`RDS` - managed MariaDB database  

Access to these instances defined by respective `Security Groups`:  
  `sg_web` allows web traffic from the internet. Attached to `web` instance.  
  `sg_bastion` allows ssh traffic from the internet. Attached to `bastion` instance.  
  `sg_db` allows mysql traffic inside SG and any traffic from `sg_bastion`.  


### Git hooks

To install pre-commit hook clone and enter repository directory, then run:   
```
./.git_hooks/_install_hook.sh
```

This hook require `shellcheck`, `tflint` and `terraform` to be installed in system.   
