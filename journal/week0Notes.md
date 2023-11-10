# Terraform Beginner Bootcamp 2023

## Table of Contents

- [Semantic Versioning](#semantic-versioning)
- [Install the Terraform CLI](#install-the-terraform-cli)
- [Shebangs.....what?](#shebangswhat)
- [Linux permissions/CHMOD](#linux-permissionschmod)
- [Refactoring into Bash Scripts](#refactoring-into-bash-scripts)
- [Execution Considerations: ](#execution-considerations)
- [Linux Permission Considerations:](#linux-permission-considerations)
- [Github Lifecycle (Before, Init, Command)](#github-lifecycle-before-init-command)
- [Env Vars](#env-vars)
- [ Remember, print with `echo`](#remember-print-with-echo)
- [Persisting Env Vars in Gitpod](#persisting-env-vars-in-gitpod)
- [AWS CLI Installation](#aws-cli-installation)
- [AWS sanity check workflow](#aws-sanity-check-workflow)
- [Terraform Registry](#terraform-registry)
- [Random Provider](#random-provider)
- [Terraform Basics](#terraform-basics)
- [Terraform Destroy](#terraform-destroy)
- [Terraform files we should know](#terraform-files-we-should-know)
- [Working in TF Cloud](#working-in-tf-cloud)
- [ tf alias](#tf-alias)
- []

## Semantic Versioning

More info available at:
[semver.org](https://semver.org/)

Given a version number **MAJOR.MINOR.PATCH**, increment the:

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

- Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format. eg `1.0.01`
- we do not need to do v1.0.01, even though many prefer to

We can also commit things to an issue, which is super cool!

### Install the Terraform CLI

The Terraform CLI Installation instructions have changed due to the gpg keyring changes. So we changed the scripting for the install in the gitpod.yml . We got the latest install instructions via Terraform Documentation

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Shebangs.....what?

A Shebang tells the Bash Script what program will interpret the script.
[Shebang on Wiki](<https://en.wikipedia.org/wiki/Shebang_(Unix)>)
`#!/bin/bash`

ChatGPT recommended that we use this format for Bash `#!/usr/bin/ env bash`

- for portability for diff OS distributions
- will search the user's PATH for the bash executable

### Linux permissions/CHMOD

This project is built using Ubuntu. Check you Linux Distribution and change according to your needs.
[How to check OS Version in Linux](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Example of checking my OS Version:

```
gitpod ~ $ cat /etc/os-release


PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

To see hidden files: ls -la
ls -la ./bin
Now let's change some permissions with chmod
![Edit using the Terraform CLI to permissions](/images/image.png)

Notice that we added the x to our permissions, that means that we turned this into an executable!
We did chmod u+x <- we added an executable to the user group

### Refactoring into Bash Scripts

While fixing the TF CLI gpg deprecation issues we noticed that the Bash scripts steps were a big chunk of code. We decided to create a Bash script to install the TF CLI

Bash script we are referring to is here: [./bin/install_terraform_cli](./bin/install_terraform_cli)

- This keeps the Gitpod Tasks file ([.gitpod.yml](.gitpod.yml)) tidy
- This allows us an easier debug and executes TF CLI install
- This allows for better portability for other projects that need to install TF CLI

### Execution Considerations:

When executing, we can use the `./` shorthand to execute the Bash Script like so `./bin/install_terraform_cli `

What does that accomplish for us? Instead of having to run
`source ./bin/install_terraform_cli`, like we do in our gitpod.yml. This version points the script to a program to interpret it.

And it will run our file to get the appropriate setup running for us.

That's how to make bash/power shell scripts!

Get good at it....

### Linux Permission Considerations:

Want to make everything executable at the user level by changing Linux perms?

```sh
chmod 777 ./bin/install_terraform_cli
```

And then fix it so it's not all executable?

```sh
chmod 744 ./bin/install_terraform_cli
```

In the gitpod.yml file, we do need to add source ./bin/install_terraform_cli bc it requires the source word

### Github Lifecycle (Before, Init, Command)

We need to be careful when using init bc it will not rerun if we restart an existing workspace

## Env Vars

#### `env` and grep commands

Want to check what current environment variables you have? In your termial, run the command

```sh
env
```

These are specifically set variables for your env. They are usually strings.
We can check the specific env vars with a command like

```sh
env | grep GITPOD
```

grep is a general Linux command to search for something specific

```sh
env | grep Amy
env | grep terraform-beginner-bootcamp
env | grep AWS_
```

To install stuff, cd out of the main dir. cd up to the main workspace
Want to spit out where you are?

```sh
echo $PROJECT_ROOT
```

When setting env vars, like in the [setup file](./bin/install_terraform_cli), remember, no space between the var name and the var value
Then, always reference it with a $ like $PROJECT_ROOT

To set an env var: (note, leave off the $! )

```sh
export PROJECT_ROOT='/workspace/terraform-beginner-bootcamp-2023/'
```

Then, to check and verify that it is set: (use the $ to ref the env var)

```sh
 echo $PROJECT_ROOT
```

We can also unset an env var: (note, leave off the $ to do this!)

```sh
 unset PROJECT_ROOT
```

We can set an env var temporarily with:

```sh
HELLO='world ./bin/print_message
```

Within a bash script we can set env var without export like:

```sh
HELLO='world'
echo $HELLO
```

#### Remember, print with `echo`

```sh
echo $HELLO
```

Each terminal env has it's own vars. If we run setting $HELLO in tf terminal, it may not work in aws cli. When you open up new bash terminals in VSCODE that you set in another window. If you want env vars to persist across all future bash terminals that are open you need to set env vars in your bash profile. (Look it up! `.bash_profile`)

#### Persisting Env Vars in Gitpod

We can persist env vars in Gitpod by storing them in Gitpod Secrets Storage.

```sh
gp env HELLO='world
```

All future workspaces launched will set the env vars for all bash terminals.
You can also set env vars in the `gitpod.yml` but this can

```sh
gp env PROJECT_ROOT='/workspace/terraform-beginner-bootcamp-2023'
```

Now this is put into secrets, so when we `echo $PROJECT_ROOT` it will be blank.

### AWS CLI Installation

To install AWS CLI into this project via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)

[AWS Getting Started Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

### AWS sanity check workflow

Don't remove the on-partial line from our Gitpod.yml, it helps us by providing an auto complete for us when we type `aws` into the terminal.
![AWS auto-complete](/images/on-partial.png)
Now, to check if we are logged in/AWS credentials are configured correctly use the AWS CLI command:

```sh
aws sts get-caller-identity
```

If we successfully set the aws cli env vars, we should see a JSON payload return that looks like this:

```json
$ aws sts get-caller-identity
{
    "UserId": "ABCDEFGHIJKLMNOPQRSTUVWXYZ123",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/terraform-bootcamp"
}
```

[AWS CLI env vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

Run the credentials freq'ly so we make sure we don't accidentally deploy the wrong company AWS account

We'll need to generate AWS CLI credentials from IAM user to generate AWS CLI.

### Terraform Registry

TF sources providers and modules from the registry.
Remember this, we will use this a lot!
[Terraform Registry](https://registry.terraform.io/)
We can do several things here. Browse providers and modules are some options

- **Providers** --> Way that we directly interact with an API to interact with TF. A mapping of AWS' API to be utilized in TF. Direct interface to create resources in Terraform.

- **Modules** --> Collection of TF files that give us a template to do commonly used actions. Use a lot of TF code with a provider? Turn it into a template that we can reuse as a module! Contain a lot of TF code. Templates for use!

### Random Provider

We use the Hashicorp random provdier to create a resource with a generated random value that we can use to access the resource.
[Lets generate some random stuff](https://registry.terraform.io/providers/hashicorp/random/latest)

## Terraform Basics

These are the main TF commands that we will work with from the TF console if we type `terraform` and hit enter :

```sh

Main commands:
  init          Prepare your working directory for other commands
  validate      Check whether the configuration is valid
  plan          Show changes required by the current configuration
  apply         Create or update infrastructure
  destroy       Destroy previously-created infrastructure
```

After running (this will download the binaries for the tf providers we'll use in the project)

```sh
terraform init
```

we can run

```sh
terraform plan
```

to see what changeset we created. In IAC, a changeset tells our plan of what we will execute to change:

```sh
gitpod /workspace/terraform-beginner-bootcamp-2023 (9-terraform-random-bucket-name) $ terraform plan

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # random_string.bucket_name will be created
  + resource "random_string" "bucket_name" {
      + id          = (known after apply)
      + length      = 16
      + lower       = true
      + min_lower   = 0
      + min_numeric = 0
      + min_special = 0
      + min_upper   = 0
      + number      = true
      + numeric     = true
      + result      = (known after apply)
      + special     = false
      + upper       = true
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + random_bucket_name_id     = (known after apply)
  + random_bucket_name_result = (known after apply)

─────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform
can't guarantee to take exactly these actions if you run "terraform
apply" now.
```

We can output the changeset (AKA plan) to be passed to an apply, but often we can ignore the outputting

```sh
terraform apply
```

will now make our plan happen! This passes the changeset to be done by TF. TF will always confirm to see if we want to deploy with yes or no. But we can auto approve with the below:

```sh
 terraform apply --auto-approve
```

Check the output in a couple of ways:

```sh
terraform output
```

OR

```sh
terraform output random_bucket_name_result
```

### Terraform Destroy

Will destroy resources that we created. We can also use the auto approve flag
`terraform apply --auto-approve`

### Terraform files we should know

- [terraform.lock.hcl](.terraform.lock.hcl) is similar to package lock in JS projects. We are locking in the versions for the providers and modules that we are using. In the tf folder, we get the tf files in go/binary from the tf registry. We don't have to write it go, but it downloads and puts it in our work area. **COMMIT THIS TO THE REPO**

- [.terraform.tfstate](terraform.tfstate) contains info about the current state of the infra. **DO NOT COMMIT THIS TO THE REPO** Put it in the [.gitignore](.gitignore) like we did. Ignore it's entire dir. This file can contain sensitive data. If you lost this file, you can lose the state of your infra.

- [.terraform.tfstate.backup](terraform.tfstate.backup) is the previous state file state.

- terraform directory contains the binaries of tf providers

### Working in TF Cloud

Projects contain workspaces.
A workspace contains an infra project.
Here is a lovely visual by Andrew Brown
![Alt text](/images/image-1.png)
We ran

```sh
terraform init
```

```sh
terraform apply --auto-approve
```

To get a new bucket that is then put in our state file. We can migrate our state file- it can be locally, in s3 or TF Cloud. In TF Cloud, we made a project, then a workspace. In that, we could use a Version control workflow which is GitOps. We commit code, when it is merged it deploys. But we are going to use a CLI-driven workflow. We could also use the API-driven, but it is advanced.

To Migrate state to cloud, we c/p the code that was created in TF Cloud.
We can do this with a

```sh
terraform init
```

We had some issues with TF Cloud Login and Gitpod Workspace.
When attempting to run `terraform login` in our tf terminal in Gitpod, it will launch a bash wisiwig view to generate a token. This does not work in Gitpod VSCode in the browser.
The workaround is manually generate a token in [Terraform Cloud](https://app.terraform.io/app/settings/tokens?source=terraform-login)

Then create and open the file like this:

```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json

```

```sh
open /home/gitpod/.terraform.d/credentials.tfrc.json
```

Provide the following code (replace your token in the file):

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR-TERRAFORM-CLOUD-TOKEN"
    }
  }
}
```

We need to document issues like this for ourself and others. The above would be fabulous to automate with a bash script at some point

### tf alias

We want to be able to type `tf` instead of `terraform` in the terminal.
First, access our bash_profile in the terminal with:

```sh
open ~/.bash_profile
```

We set an alias in our bash profile like this

```sh
# set our terraform bash commmand to tf
alias tf="terraform"
```

Now, when we set a new alias, we need to run our bash_file script with:

```sh
source ~/.bash_profile
```

Then, in the terminal, run `tf` and you will see that the alias is applied and we can now access the terraform commands with `tf`

In order for Gitpod to load and run the above every time we open our project, we need to write a bash script to load the alias to our bash_profile.

We have automated the TF Cloud login process using the following bash script [bin/generate_tfrc_credentials](./bin/generate_tfrc_credentials)
