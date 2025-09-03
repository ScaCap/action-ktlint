terraform {
  required_version = "= 1.10.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.85.0"
    }
    datadog = {
      source = "DataDog/datadog"
    }
  }

  backend "s3" {
  }
}

provider "aws" {
  region = "eu-central-1"
}
