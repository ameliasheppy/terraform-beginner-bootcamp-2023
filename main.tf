# this is the work flow
# make a change, then under the source control tab, we can commit through that tab

#On the Terraform Provider page, under **Use Provider** button, c/p the code:
# making a main.tf file is making our own module/top level root level module
#           YOU CAN ONLY HAVE ONE TERRAFORM AND ONE PROVIDER BLOCK!

#moving the below provider info to providers.tf

#This will fail:  (tf plan has no idea that this will give us a bucket name that contains capital letters which will fail the S3 bucket naming rules)
#Bucket naming rules: https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html
# resource "aws_s3_bucket" "website_bucket" {
#   bucket = var.bucket_name

#   tags = {
#     UserUuid = var.user_uuid
#   }
# }


terraform {
  required_providers {
      terratowns = {
        source = "local.providers/local/terratowns"
        version = "1.0.0"
      }
  }
}

provider "terratowns" {
  endpoint = "http://localhost:4567/api"
  user_uuid="e328f4ab-b99f-421c-84c9-4ccea042c7d1" 
  token="9b49b3fb-b8e9-483c-b703-97ba88eef8e0"
}
# There are many sources we can use for modules, but we are using a local source here
# module "terrahouse_aws" {
#   source = "./modules/terrahouse_aws"
#   user_uuid = var.user_uuid
#   bucket_name = var.bucket_name
#   error_html_filepath = var.error_html_filepath
#   index_html_filepath = var.index_html_filepath
#   content_version = var.content_version
#   assets_path = var.assets_path
# }

resource "terratowns_home" "home" {
  name = "Why the Outer Banks of North Carolina are a great vacation spot"
  description = <<-DESCRIPTION
    The Outer Banks is a long strip of barrier islands with lots of peaceful areas 
    and fun activities suitable for all ages and activity levels. Come enjoy some fun year-round!
  DESCRIPTION

  # domain_name = module.terrahouse_aws.cloudfront_url
  domain_name = "3fdq3gz.cloudfront.net"
  town = "the-nomad-pad"
  content_version = 1
}