terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4"
    }
  }
   backend "s3" {
      region = var.region
   }  
}

provider "aws" {
  region  = var.region
  
}