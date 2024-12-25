#!/bin/bash

sudo apt update
sudo apt install -y unzip curl nginx

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

rm -rf aws*

# Retrieve Secrets
SECRET=$(aws secretsmanager get-secret-value --secret-id mysecuresecret --query SecretString --output text)

DB_ENDPOINT=$(aws rds describe-db-instances \
    --query "DBInstances[?DBInstanceIdentifier=='mydbinstance'].Endpoint.Address" \
    --output text)

DB_USERNAME=$(echo $SECRET | jq -r '.DB_USERNAME')
DB_PASSWORD=$(echo $SECRET | jq -r '.DB_PASSWORD')

echo "<h1>Hello from Terraform at $(hostname -f)</h1>" | sudo tee /var/www/html/index.html
echo "<h2>DB Username: $DB_USERNAME</h2>" | sudo tee -a /var/www/html/index.html
echo "<h2>DB Password: $DB_PASSWORD</h2>" | sudo tee -a /var/www/html/index.html