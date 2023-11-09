#some argue that this should stay in main, go with what your team wants!

terraform {
  #   cloud {
  #   organization = "thegirl033007"

  #   workspaces {
  #     name = "terra-house-1"
  #   }
  # }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.16.2"
    }
  }
}

provider "aws" {
}

#Random docs: https://registry.terraform.io/providers/hashicorp/random/latest
#We had been utilizing random to generate our bucket names, but we took it out