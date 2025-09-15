# pex-infra-repo
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)

This repository contains infrastructure code for deploying a web application on AWS using Terraform.



## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |


## Quick Start

To run locally:  

1. **Clone the repository:**
   ```bash
   git clone https://github.com/DvO-test-org/pex-infra-repo.git
   cd pex-infra-repo
   ```

2. **Switch to environment directory (currently - `dev`):**
    ```bash
    cd terraform/dev
    ```

3. **Initialize Terraform:**
   ```bash
   terraform init
   ```

4. **Review planned changes:**
   ```bash
   terraform plan
   ```

5. **Apply infrastructure:**
   ```bash
   terraform apply
   ```

## Architecture

The infrastructure includes:

- **VPC** with 2 private and 2 public subnets across 2 availability zones
- **NAT Gateway** for outbound traffic from private subnets
- **2 EC2 instances**:
  - `web` - sample web application in public subnet
  - `bastion` - bastion host for secure infrastructure access
- **RDS MariaDB** - managed database
- **Security Groups** for access control
- **elasticsearch** EC2 instance with single-node sample Elasticsearch 

## Project Structure

```
terraform/
├── core/
│   └── tf_backend/
│       ├── backend_bucket.tf    # S3 bucket for Terraform state
│       └── provider.tf
└── dev/
    ├── backend.tf               # Remote state configuration
    ├── db_maria.tf             # RDS MariaDB
    ├── iam.tf                  # IAM roles and policies
    ├── main.tf                 # Main configuration
    ├── outputs.tf              # Output values
    ├── provider.tf             # AWS provider
    ├── s3.tf                   # S3 bucket for backups
    ├── sg.tf                   # Security Groups
    ├── templates/
    │   ├── deploy_app.sh       # Application deployment script
    │   └── deploy_db.sh        # Database setup script
    ├── terraform.tfvars        # Environment variables values
    ├── variables.tf            # Variable definitions
    ├── versions.tf             # Provider versions
    └── vpc.tf                  # VPC and network configuration
```

## Security Groups

| Security Group | Purpose | Rules |
|---|---|---|
| `sg_web` | Web server | Allows HTTP/HTTPS traffic from internet |
| `sg_bastion` | Bastion host | Allows SSH traffic from internet |
| `sg_db` | Database | Allows MySQL traffic within SG and from bastion SG |

## Secrets
RDS set up with managed master password, so data:  
```hcl 
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = local.rds_master_secret_arn
}
```
used to bootstrap web app  with connection information  


## Variables

Variables are defined and described in `variables.tf`
Only variable __required__ to be set in `terraform.tfvars`:
```
aws_account_id = 123456789012
```

## Outputs

After successful deployment, the following will be displayed:

- Bastion instance public ip
- Web instance public ip
- Web instance private ip
- Elasticsearch EC2 instance ID
- Elasticsearch EC2 instance private ip
- Elasticsearch private url
- RDS endpoint
- Web instance connection hint

## Connecting to Infrastructure

### SSH access via bastion:

```bash
# Connect to bastion
ssh -i your-key.pem ubuntu@<bastion-public-ip>

# Connect to web server through bastion
ssh -i your-key.pem -J ubuntu@<bastion-public-ip> ubuntu@<web-private-ip>
```


# Custom AMI

## Packer + Ansible
In `packer` dir packer configuration present to build custom AMI with mysql.     
In `ansible` dir example ansible code present.   
It uses ansible role `db` for provisioning AMI.  

### Git hooks

To install pre-commit hook clone and enter repository directory, then run:   
```
./.git_hooks/_install_hook.sh
```

This hook require `shellcheck`, `tflint` and `terraform` to be installed in system.   
