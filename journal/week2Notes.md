## New Task Setup
We took the task from the cloned **NOT** a submodule gitpod.yml and put it into our root gitpod.yml. 
When we did so, we also wanted to make sure that in our before statements, we cd $PROJECT_ROOT.
Then we could delete the gitpod.yml in the cloned repo.
The new task to cd terratowns_mock_server will run a bundle install, similar to an npm install, but Ruby style. 
`bundle exec ruby server.rb` will start our Ruby server. 
^^^ Similar to a package manager like npm! 
We need to make sure that all of our dirs are readable and writeable, so we move them into our root bin dir. This way we don't have two bins to manage. It keeps our actions we will be able to perform nice and neat. 
Now we can apply our perms in the console for our CRUD to make them all executable.
```sh
chmod u+x bin/terratowns/*
```
### Working with Ruby
Bundler is a package manager for Ruby. The primary way to install Ruby packages, known as gems, for Ruby. 

#### Install Gems
You need to create a Gemfiles and define the gems in that file, liek we did. 

```rb
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
```

Then run the `bundle install` command to install the gems on the sys globally. NodeJS only installs packages in place in the node_modules. A gemlock file is created to lock down the gem versions being used in your project 

#### Executing Ruby scripts in the context of bundler
We have to use `bundle exec ` to tell future ruby scripts to use the gems we installed. This sets context. 

### Sinatra
This is a micro web framework for Ruby to build web apps. Its great for mock or development servers OR very simple projects. Create a web server in a single file.

https://sinatrarb.com/

## Terratowns Mock Server 

### Running the web server 
We can run the web server with the following commands. 
```rb
bundle install
bundle exec ruby server.rb
```

All of the code for our server is stored in the `server.rb` file. 

Anything that starts with $ in Ruby is a global var. 

In our `server.rb` file, we have a global var 
```rb
$home = {}
```
We would NEVER put a global var in a production server! We are just mocking having state or a db for this dev server. 

There is a Ruby class Home that includes validations from ActiveRecord. It reps our Home resources as a Ruby obj. 
The Active Model is a part of RoR. Used as an ORM. It has a module within ActiveModel that provides validations. 
The production TerraTowns server is rails and uses very similar/identical validation. 

We create attributes that are stored on our obj. Includes setting a getter and setter
home = new Home()
home.town = 'hello' # setter
home.town() # getter 
Validates is used for validating in Ruby. It shows us the things that must be present. 

The other validates set our visiblity to public, but we lock our cloudfront info down. 



**As a cloud engineer** get used to programming and working with languages that we only may have a highlevel familiarity with. 

#### Just for clarity:
To make sure that our Create works from our bin, we ran 
`./bin/terratowns/create` and it generated a random uuid for us. Yay!
Then we ran `./bin/terratowns/read <uuid that we just created>` and it showed us the payload. Sweet! 

## Making a TF Provider for Terratowns

Super small reminder that echo is awesome! 
We needed to set the $PROJECT_ROOT in our build_provider. So we checked the var with: `echo $PROJECT_ROOT` in the terminal. 