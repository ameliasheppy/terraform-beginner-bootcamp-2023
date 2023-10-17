# Terraform Beginner Bootcamp 2023

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
[Shebang on Wiki](https://en.wikipedia.org/wiki/Shebang_(Unix))
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
![Edit using the Terraform CLI to permissions](image.png)

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

