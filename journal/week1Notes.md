### S3 buckets hold things

Remember, bucket names are in the global name space, they must be unique.
Global namespace means that we can't name our bucket the same name as someone else's bucket. But each cloud provider has it's own naming rules.
s3 buckets are global, but you set a region on the bucket
BC the namespace is global, but the storage is regional

### Tf Refresh
```sh
terraform apply -refresh-only -auto-approve
```

### Chris holding down the fort with some security knowledge

Choose a region so that you know what hard drive it is written to
Block public access means that others can't access your bucket
Keep your buckets locked down
Bucket versioning is good to use
It helps you to add a new version each time that you add.
If someone gets into account, they can only delete up to a certain point.
We are storing back end state in TF Cloud so that it is versioned and protected.
This will keep your ARN's secure!
Make sure that your state file is unavailable to the outside!
TF Cloud has tons of security! If you are using S3 to store instead of TF Cloud, have bucket versioning on bc every change to the state file will be tracked.

### npm install --global http-server

to get our server running
then `http-server` to get it running

### aws cli

Want to see your buckets?
`aws` will bring up a menu, go from there!

```sh
gitpod /workspace/terraform-beginner-bootcamp-2023 (main) $ aws s3
> aws s3 ls
2023-09-11 22:55:26 redacted bucket name
2023-10-23 03:35:32 redacted bucket name

```

Now let's send our index.html to an s3 with the below command:

```sh
ws s3 cp public/index.html s3://redactedBucketName/index.html

# This will be the response message
Completed 252 Bytes/252 Bytes (588 Bytes/s) withupload: public/index.html to s3://redactedBucketName/index.html
```

## Root Module Structure

Our root module structure is this:

```
PROJECT_ROOT
│
├── main.tf                 # everything else.
├── variables.tf            # stores the structure of input variables
├── terraform.tfvars        # the data of variables we want to load into our terraform project
├── providers.tf            # defined required providers and their configuration
├── outputs.tf              # stores our outputs
└── README.md               # required for root modules
```

https://developer.hashicorp.com/terraform/language/modules/develop/structure


### Token Refresher!
Andrew's token had expired for TF Cloud so he went and created a new one and then set it to the env with 
`gp env TERRAFORM_CLOUD_TOKEN="andrewsFancySecretToken!"`
 and then `export TERRAFORM_CLOUD_TOKEN="andrewsFancySecretToken!"`

Then run the bin!
## TF and input vars
### TF Cloud vars
In tf we can set 2 kinds of vars:
- Env vars - eg AWS credentials we can set in bash
- tf vars - those we'd set in the tfvars file like the user_uuid

We can set our tf cloud vars as sensitive so they aren't shown in the UI.

### Loading TF input vars 

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)
### var flag
We can use the `-var` flag to set an input var or override a var in the tfvars file like we did with `tf -var user_uuid="5ab644ae-ad4e-4258-b655-bd46ce69829d"`
or `tf plan -var user_uuid="5ab644ae-ad4e-4258-b655-bd46ce69829d"`

### var-file flag
- TODO: document this flag

### terraform.tfvars
This is the default file to load in tf vars

### auto.tfvars
- TODO: document this functionality for tf cloud

### order of tf vars
- TODO: document which tf vars takes presidence

## Managing Configuration Drift

## What happens if we lose our state file?
If you lose your state file, you most likely have to tear down all of your cloud infra manually.

You can use tf import but it won't for all cloud resources. You need check the terraform providers documentation for which resources support import.

### Fix Missing Resources With Terraform import
If a junior accidentally or intentionally deletes a needed bucket, how will tf deal with the bucket being gone?
Tf always checks the state for us. Tf looks to the state file to see what is there, what is missing, and with running `tf plan` (our great iac tool) we can make our bucket come back
[AWS S3 Bucket Import ](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

```sh
terraform import aws_s3_bucket.bucket bucket-name
```


### Fix Manual Configuration
If someone goes and deletes or modifies cloud resources manually through ClickOps, we can run `tf plan` again and it will attempt to put our infra back into the expected state which will fix our config drift. 


## Module nesting 
We are making a module folder to hold our modules that we use

## Terraform Modules

### Terraform Module Structure

It is recommend to place modules in a `modules` directory when locally developing modules but you can name it whatever you like.

### Passing Input Variables

We can pass input variables to our module.
The module has to declare the terraform variables in its own variables.tf

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Modules Sources

Using the source we can import the module from various places such as:
- locally
- Github
- Terraform Registry

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```


[Modules Sources](https://developer.hashicorp.com/terraform/language/modules/sources)

## Considerations when using ChatGPT to write TF

LLM's such as ChatGPT may not be trained on the latest docs or info about TF. 

It may produce older examples that could be deprecated. Often affeceting providers. 

## Working with Files in Terraform

TF has built in functions that we can uae! We used a couple, but there are a lot more to learn about!


### Fileexists function

This is a built in terraform function to check the existance of a file.

```tf
condition = fileexists(var.error_html_filepath)
```

https://developer.hashicorp.com/terraform/language/functions/fileexists

### Filemd5
A function that creates a hash based on the content
A cryptographic algo
https://developer.hashicorp.com/terraform/language/functions/filemd5

### Etags
https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/ETag
Pretty cool! If your content changes, they trigger a change!

### Path Variable

In terraform there is a special variable called `path` that allows us to reference local paths:
- path.module = get the path for the current module
- path.root = get the path for the root module
[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)


resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html"
}

## Terraform Locals

Locals allows us to define local variables.
It can be very useful when we need transform data into another format and have it referenced a varaible.

```tf
locals {
  s3_origin_id = "MyS3Origin"
}
```
[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

## Terraform Data Sources

This allows use to source data from cloud resources. Using data sources using the data block.

This is useful when we want to reference cloud resources without importing them.

```tf
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```
[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

It's like saying "there is an AMI we'll call example and we will give it these properties."



## Working with JSON

We use the jsonencode to create the json policy inline in the hcl.

```tf
> jsonencode({"hello"="world"})
{"hello":"world"}
```

[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

## Resource Storage Issues

Don't forget to set the content type. If you don't do this line of code, it will download the file. 
```tf 
  content_type = "text/html"
```
Then, when we added the code line, it downloads it again, so be sure to go into the Create Invalidation `/*` in the CF Distributions of your AWS Mgmt Console and then this will clear the cache of the file. This allows us to serve it instead of download the file. 

Make sure that if you use the above html conten type that you use actual html in your files!


### Changing the Lifecycle of Resources

[Meta Arguments Lifcycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

We only want for our content version to change when we update certain files or values

## Terraform Data

Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

https://developer.hashicorp.com/terraform/language/resources/terraform-data

## Provisioners

Provisioners allow you to execute commands on compute instances eg. a AWS CLI command. We could place it in a resource as part of it.

They are not recommended for use by Hashicorp because Configuration Management tools such as Ansible are a better fit, but the functionality exists. Use Ansible when possible!

A VM allows you to feed a bash script or YAML, and with Ansible and Puppet, you can see each step as it goes to roll it back if needed. 


[Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

### Local-exec

This will execute command on the local machine running the terraform commands eg. plan, apply.


```tf
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}
```

https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec

### Remote-exec

This will execute commands on a machine which you target. You will need to provide credentials such as ssh to get into the machine. Points to external compute that you can login to with ssh. 

```tf
resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
```
https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec

### Heredoc Strings:
A way that we can make multiline comments. Its two open angle brackets `<<`
```tf
 command = <<COMMAND
aws cloudfront create-invalidation \
--distribution-id ${aws_cloudfront_distribution.s3_distribution.id} \
--paths '/*'
    COMMAND

```

## Using assets folder and loops

In TF, we have uploaded one file at a time. But what if we want to upload multiple at one time? 
Generally other declarative IAC tools can't loop through multiples. But we can go into our resource-storage and use a for each! 
ChatGPT breaks the code to even attempt this. Don't try to use it unless you're Andrew or Bayko.

Go into the tf console with 
```tf
tf console
```
Now we can do some fun functions! Look at the TF docs and see what we can do with fileset
Check where you are with:
```tf
path.root
```

Now see what is here with fileset and string interpolation. Put in the path and the pattern to look for as args. We want to look at all of it.
```tf
fileset("${path.root}/public/assets", "*)
```

We can look at different ds in tf. There are more complex, structural types like a list(tuple), map(object). There are restrictions of how we can use the complex types. 
A complex type is a type that groups multiple vars into a single value. 
Complex types are rep'd by type constructors, but several of them also have shorthand keyword versions. 
There are two categories of complex types:
- collection types (for grouping similar values) -> list(should all be string), map, set
- structural types (for grouping potentially NOT similar values) --> tuple, object
These types make the lang more proficient. 
A function expects one type at times, and you must cast it to a particular type. Casting can be a pain, but you can trace what you need and figure it out! Won't use day to day in tf probably. 

## For Each Expressions

For each allows us to enumerate over complex data types

```sh
[for s in var.list : upper(s)]
```

This is mostly useful when you are creating multiples of a cloud resource and you want to reduce the amount of repetitive terraform code.

[For Each Expressions](https://developer.hashicorp.com/terraform/language/expressions/for)

