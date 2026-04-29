terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }

  /*backend "s3" {
    bucket = "evnmontalvo-terraform-example"
    key    = "global/s3/terraform.tfstate"
    region = "us-east-1"

    # DynamoDB table
    dynamodb_table = "terraform_state_lock"
    encrypt        = true
  } */
}

/*provider "aws" {
  region = "us-east-1"
}
*/
# AWS S3 bucket

# Bucket definition

/*resource "aws_s3_bucket" "terraform_state" {
  bucket = "evnmontalvo-terraform-example"

  # Prevent accidental delection of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }
}

# S3 Versioning
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 encryptation 
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Explicit block public access to S3 bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Dynamodb table for lock terraform state
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform_state_lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  # Colums definition
  attribute {
    name = "LockID"
    type = "S"
  }
}*/