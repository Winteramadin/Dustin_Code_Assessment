terraform {
  # backend "s3" {
  #   bucket = "my-remote-state-bucket-for-dustin"
  #   key    = "terraform.tfstate"
  #   region = "eu-west-2"
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.5"
    }
  }
}

# setting default provider region
provider "aws" {
  region = "eu-west-2"
}

# getting amazon linux 2 ami automatically from amazon
data "aws_ami" "ec_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}