provider "aws" {
  version = "~> 0.1"
}

terraform {
  backend "s3" {
    bucket = "acid232-devsecops-eu-central-1"
    key = "terraform/terraform.tfstate"
  }
}
