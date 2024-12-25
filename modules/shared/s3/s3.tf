terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws]
    }
  }
}

resource "random_string" "name" {
  special = false
  upper   = false
  length  = 8
}

resource "aws_iam_role" "replication_role" {
  count = var.create_source ? 1 : 0

  name = "s3_replication_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_s3_bucket" "bucket" {
  bucket        = "${var.environnment}-backup-${random_string.name.result}"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "replication_configuration" {
  count  = var.create_source ? 1 : 0
  bucket = aws_s3_bucket.bucket.id
  role   = aws_iam_role.replication_role[count.index].arn

  rule {
    id     = "ReplicationRule"
    status = "Enabled"
    destination {
      bucket = var.destination_bucket.arn
    }
    filter {
      prefix = ""
    }
    delete_marker_replication {
      status = "Enabled"
    }
  }

  depends_on = [aws_s3_bucket_versioning.versioning]
}