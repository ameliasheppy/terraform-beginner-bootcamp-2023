# this is the work flow
# make a change, then under the source control tab, we can commit through that tab

#On the Terraform Provider page, under **Use Provider** button, c/p the code:
# making a main.tf file is making our own module/top level root level module
#           YOU CAN ONLY HAVE ONE TERRAFORM AND ONE PROVIDER BLOCK!

#moving the below provider info to providers.tf

#our resource we are applying random to is a bucket name
#set lower = true so that we are following s3 naming policies
resource "random_string" "bucket_name" {
  lower = true
  upper = false
  length  = 32
  special   = false
}

# resource "aws_s3_bucket" "example" {
#   bucket = "my-tf-test-bucket"  

#   tags = {
#     Name        = "My bucket"
#     Environment = "Dev"
#   }
# }

#This will fail:  (tf plan has no idea that this will give us a bucket name that contains capital letters which will fail the S3 bucket naming rules)
#Bucket naming rules: https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html
resource "aws_s3_bucket" "example" {
  bucket = random_string.bucket_name.result  

  tags = {
    UserUuid = var.user_uuid
  }
}
#When we run TF plan, we get an error of: 
#     Error: Inconsistent dependency lock file
#That means that any time that we add a new provider, we need to run terraform init bc it will add the binaries for that provider
# We also can't do aws sts get-caller-identity in the tf bash. Need to do it from the aws-cli. If the provider is not working, it is probably caused by an error with the env vars. env|grep AWS_ to check!
# How do env vars make it to the aws config? 
# DO NOT hard code them in your main.tf. <-----Bad idea!



#don't really need both of the below. Commenting one out.
# output "random_bucket_name_id" {
#   value = random_string.bucket_name.id
# }

#moving to outputs.tf!


