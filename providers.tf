#some argue that this should stay in main, go with what your team wants!

terraform {
  #   cloud {
  #   organization = "thegirl033007"

  #   workspaces {
  #     name = "terra-house-1"
  #   }
  # }
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.16.2"
    }
  }
}

provider "aws" {
}

#Random docs: https://registry.terraform.io/providers/hashicorp/random/latest
provider "random" {
  # Configuration options
}