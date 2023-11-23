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
  cloud {
        organization = "thegirl033007"
    workspaces {
      name = "terraform-cloud"
    }
  }
}
# There are many sources we can use for modules, but we are using a local source here
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
  error_html_filepath = var.error_html_filepath
  index_html_filepath = var.index_html_filepath
  content_version = var.content_version
  assets_path = var.assets_path
}