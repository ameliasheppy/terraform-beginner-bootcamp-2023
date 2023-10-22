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

#our resource we are applying random to is a bucket name
resource "random_string" "bucket_name" {
  length           = 16
  special          = false
}

#don't really need both of the below. Commenting one out.
# output "random_bucket_name_id" {
#   value = random_string.bucket_name.id
# }

output "random_bucket_name_result" {
  value = random_string.bucket_name.result
}


