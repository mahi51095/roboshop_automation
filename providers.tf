terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.15.0"  # Use a stable version
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


terraform {
  backend "s3" {
    bucket         = "roboshop-remote-sample"  # No spaces, valid name
    key            = "env:/terraform.tfstate"  # Adjust path as needed
    region         = "us-east-1"              # Match your bucket’s region
    dynamodb_table = "roboshop-lock"          # Optional, for locking
  }
}