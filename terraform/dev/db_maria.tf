
resource "aws_db_instance" "rds_demo" {
  identifier     = "${var.Environment}-rds-db"
  instance_class = "db.t3.micro"

  engine         = "mariadb"
  engine_version = "10.6"

  allocated_storage = 5
  # max_allocated_storage  = 10
  # storage_type = "standard" # (magnetic)
  # "gp2" (default)
  # "gp3"
  # "io1"

  username                    = "admin"
  manage_master_user_password = true

  db_name = "flask_db"

  db_subnet_group_name   = aws_db_subnet_group.rds_demo.name
  vpc_security_group_ids = [aws_security_group.sg_db.id]
  parameter_group_name   = aws_db_parameter_group.rds_demo.name

  apply_immediately = true

  publicly_accessible = false
  skip_final_snapshot = true
}

resource "aws_db_subnet_group" "rds_demo" {
  name       = "${var.Environment}-db-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "rds_demo-db-subnet-group"
  }
}

resource "aws_db_parameter_group" "rds_demo" {
  name   = "${var.Environment}-db-param-group"
  family = "mariadb10.6"

  parameter {
    name  = "max_connections"
    value = "50"
  }
}