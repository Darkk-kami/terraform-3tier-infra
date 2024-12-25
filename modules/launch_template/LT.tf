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

  iam_instance_profile {
    arn = var.instance_profile.arn
  }

  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type



  vpc_security_group_ids = [module.security_group.security_group_id]

  user_data = base64encode(<<-EOT
  #!/bin/bash
  sudo apt update -y
  sudo apt upgrade -y

  sudo apt install -y unzip curl nginx

  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install

  rm -rf aws*

  sudo systemctl start nginx
  sudo systemctl enable nginx

  # Retrieve the secret from AWS Secrets Manager
  SECRET=$(aws secretsmanager get-secret-value --secret-id mysecuresecret --query SecretString --output text)

  DB_ENDPOINT=$(aws rds describe-db-instances \
    --query "DBInstances[?DBInstanceIdentifier=='${var.rds_identifier}'].Endpoint.Address" \
    --output text)

  # Extract DB_USERNAME and DB_PASSWORD from the JSON response
  DB_USERNAME=$(echo $SECRET | jq -r '.DB_USERNAME')
  DB_PASSWORD=$(echo $SECRET | jq -r '.DB_PASSWORD')

  # Print the values to the Nginx index.html
  echo "<h1>Hello from Terraform at $(hostname -f)</h1>" | sudo tee /var/www/html/index.html
  echo "<h2>DB Username: $DB_USERNAME</h2>" | sudo tee -a /var/www/html/index.html
  echo "<h2>DB Password: $DB_PASSWORD</h2>" | sudo tee -a /var/www/html/index.html
  echo "<h2>DB Endpoint: $DB_ENDPOINT</h2>" | sudo tee -a /var/www/html/index.html
  EOT
  )

  depends_on = [var.rds_identifier]
}