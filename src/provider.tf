terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4"
    }
  }
   backend "s3" {
      region = "us-east-1"
   }  
}

provider "aws" {
  region  = var.region
  
}