# this is the work flow
# make a change, then under the source control tab, we can commit through that tab

#On the Terraform Provider page, under **Use Provider** button, c/p the code:
# making a main.tf file is making our own module/top level root level module
terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "random" {
  # Configuration options
}