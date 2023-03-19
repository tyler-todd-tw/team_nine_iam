terraform {
  required_version = "~> 1.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
    datadog = {
      source = "DataDog/datadog"
    }
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "twdps"
    workspaces {
      prefix = "lab-iam-profiles-"
    }
  }
}

provider "aws" {
  region = var.aws_default_region

  # this section commented out during the initial bootstrap run
  # once the assumeable roles are created, uncomment and change
  # secrethub.*.env to contain the appropriate service account identity
  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_account_role}"
    session_name = "lab-iam-profiles"
  }

  default_tags {
    tags = {
      pipeline = "lab-iam-profiles"
    }
  }
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}
