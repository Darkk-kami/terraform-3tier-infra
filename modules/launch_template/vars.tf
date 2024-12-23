variable "environment" {
  type    = string
  default = "dev"
}

variable "distro_version" {
  type    = string
  default = "24.04"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "vpc_id" {
  type = string
}

variable "alb_security_group_id" {
}

variable "subnet" {

}