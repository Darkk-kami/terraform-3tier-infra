terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws]
    }
  }
}

module "security_group" {
  count                 = var.create_replica ? 0 : 1
  source                = "../shared/security_groups"
  vpc_id                = var.vpc_id
  allow_internet_access = false
  inbound_ports         = var.inbound_ports
  security_group_ref_id = var.web_server_security_group_id
}

resource "aws_db_subnet_group" "main" {
  name       = "my-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "MyDBSubnetGroup"
  }
}

resource "aws_db_instance" "db" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  identifier             = "${var.rds_identifier}-${var.instance_role}"
  username               = var.create_replica ? null : var.db_username
  password               = var.create_replica ? null : var.db_password
  parameter_group_name   = "default.mysql8.0"
  publicly_accessible    = false
  vpc_security_group_ids = var.create_replica ? null : [module.security_group[0].security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  replicate_source_db    = var.create_replica ? var.source_db : null

  multi_az                = false
  backup_retention_period = 7
  skip_final_snapshot     = true

  tags = {
    Name = "${var.environment}-${var.instance_role}-rds"
  }
}
