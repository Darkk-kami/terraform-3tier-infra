module "vpc" {
  cidr_block         = var.primary_cidr_block
  source             = "../../modules/vpc"
  dns_hostnames      = true
  desired_azs        = 2
  private_subnets_no = 3
  public_subnets_no  = 2

  providers = {
    aws = aws.primary
  }
}

module "alb" {
  source              = "../../modules/alb"
  environment         = var.environment
  alb_subnets         = module.vpc.public_subnet_ids
  vpc_id              = module.vpc.vpc_id
  use_ssl             = true
  acm_certificate_arn = module.route_53.acm_certificate_arn
}

module "s3_bucket_source" {
  source             = "../../modules/shared/s3"
  create_source      = true
  destination_bucket = module.s3_bucket_destination.s3_bucket
  depends_on         = [module.s3_bucket_destination]

  providers = {
    aws = aws.primary
  }
}

module "instance_profile" {
  source        = "../../modules/instance_profile"
  secret_name   = var.secret_name
  region        = var.primary_region
  source_bucket = module.s3_bucket_source.s3_bucket
}

module "launch_template" {
  source                = "../../modules/launch_template"
  vpc_id                = module.vpc.vpc_id
  distro_version        = "24.04"
  alb_security_group_id = module.alb.alb_security_group_id
  subnet                = module.vpc.private_subnet_ids
  instance_profile      = module.instance_profile.instance_profile
  rds_identifier        = module.rds.rds_instance.identifier
}

module "asg" {
  source             = "../../modules/asg"
  alb_target_group   = module.alb.alb_target_group
  private_subnet_ids = module.vpc.private_subnet_ids
  launch_template    = module.launch_template.launch_template
}

module "rds" {
  source                       = "../../modules/rds"
  db_password                  = module.instance_profile.secret.DB_PASSWORD
  db_username                  = module.instance_profile.secret.DB_USERNAME
  rds_identifier               = var.rds_identifier
  web_server_security_group_id = module.launch_template.web_server_security_group_id
  vpc_id                       = module.vpc.vpc_id
  private_subnet_ids           = module.vpc.private_subnet_ids
  environment                  = var.environment
  instance_role                = "primary"

  providers = {
    aws = aws.primary
  }
}


module "route_53" {
  source      = "../../modules/route_53"
  domain_name = var.domain_name
  alb_dns     = module.alb.alb_dns
  alb_zone_id = module.alb.alb_hosted_zone_id
}



# *********************************   Second Region  ********************************************************
module "vpc_secondary" {
  source             = "../../modules/vpc"
  cidr_block         = var.secondary_cidr_block
  dns_hostnames      = true
  desired_azs        = 2
  private_subnets_no = 2
  public_subnets_no  = 1

  providers = {
    aws = aws.failover
  }
}

module "s3_bucket_destination" {
  source        = "../../modules/shared/s3"
  create_source = false

  providers = {
    aws = aws.failover
  }
}

module "rds_secondary" {
  source                       = "../../modules/rds"
  db_password                  = module.instance_profile.secret.DB_PASSWORD
  db_username                  = module.instance_profile.secret.DB_USERNAME
  rds_identifier               = var.rds_identifier
  web_server_security_group_id = module.launch_template.web_server_security_group_id
  vpc_id                       = module.vpc_secondary.vpc_id
  private_subnet_ids           = module.vpc_secondary.private_subnet_ids
  environment                  = var.environment

  instance_role  = "replica"
  create_replica = true
  source_db      = module.rds.rds_instance.arn

  providers = {
    aws = aws.failover
  }
}



# ************************************ MULTI REGION MODULES *********************************

module "vpc_peering" {
  source        = "../../modules/multi-region/vpc_peering"
  vpc_requester = module.vpc.vpc_id
  vpc_accepter  = module.vpc_secondary.vpc_id

  providers = {
    aws.primary   = aws.primary
    aws.secondary = aws.failover
  }
}

module "cloud_watch" {
  providers = {
    aws.primary   = aws.primary
    aws.secondary = aws.failover
  }
  source                            = "../../modules/multi-region/cloud_watch"
  asg                               = module.asg.asg
  asg_policy                        = module.asg.scaling_policies
  primary_rds_instance_identifier   = module.rds.rds_instance.identifier
  secondary_rds_instance_identifier = module.rds_secondary.rds_instance.identifier
}


module "failover" {
  source = "../../modules/multi-region/route53failover"
  providers = {
    aws.primary   = aws.primary
    aws.secondary = aws.failover
  }
  environment                     = var.environment
  primary_vpc_id                  = module.vpc.vpc_id
  secondary_vpc_id                = module.vpc_secondary.vpc_id
  primary_db                      = module.rds.rds_instance
  secondary_db                    = module.rds_secondary.rds_instance
  primary_rds_cloud_watch_alarm   = module.cloud_watch.primary_rds_connections_alarm
  secondary_rds_cloud_watch_alarm = module.cloud_watch.secondary_rds_replica_lag_alarm
}