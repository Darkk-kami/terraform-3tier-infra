module "vpc" {
  source             = "../../modules/vpc"
  dns_hostnames      = true
  desired_azs        = 2
  private_subnets_no = 2
  public_subnets_no  = 2
}

module "alb" {
  source      = "../../modules/alb"
  environment = var.environment
  alb_subnets = module.vpc.public_subnet_ids
  vpc_id      = module.vpc.vpc_id
}

module "launch_template" {
  source                = "../../modules/launch_template"
  vpc_id                = module.vpc.vpc_id
  distro_version        = "24.04"
  alb_security_group_id = module.alb.alb_security_group_id
  subnet                = module.vpc.private_subnet_ids
}

module "asg" {
  source             = "../../modules/asg"
  alb_target_group   = module.alb.alb_target_group
  private_subnet_ids = module.vpc.private_subnet_ids
  launch_template    = module.launch_template.launch_template
}

module "cloud_watch" {
  source     = "../../modules/cloud_watch"
  asg        = module.asg.asg
  asg_policy = module.asg.scaling_policies
}

