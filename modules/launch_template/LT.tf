module "security_group" {
  source                = "../shared/security_groups"
  vpc_id                = var.vpc_id
  inbound_ports         = [80]
  allow_internet_access = false
  security_group_ref_id = var.alb_security_group_id
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd*/ubuntu-*-${var.distro_version}-amd64-server-*"]
  }

  owners = ["099720109477"]
}


resource "aws_launch_template" "launch_template" {
  name = "${var.environment}-launch-template"

  disable_api_stop        = true
  disable_api_termination = false

  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [module.security_group.security_group_id]

  user_data = base64encode(<<-EOT
    #!/bin/bash
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
    echo "<h1>Hello from Terraform at $(hostname -f)</h1>" | sudo tee /var/www/html/index.html
  EOT
  )
}


# resource "aws_instance" "name" {
#   launch_template {
#     id = aws_launch_template.launch_template.id
#     version = aws_launch_template.launch_template.latest_version
#   }

#   associate_public_ip_address = true
#   subnet_id = var.subnet[0]

#   tags = {
#     Name = "testes"
#   }
# }