## New Task Setup
We took the task from the cloned **NOT** a submodule gitpod.yml and put it into our root gitpod.yml. 
When we did so, we also wanted to make sure that in our before statements, we cd $PROJECT_ROOT.
Then we could delete the gitpod.yml in the cloned repo.
The new task to cd terratowns_mock_server will run a bundle install, similar to an npm install, but Ruby style. 
`bundle exec ruby server.rb` will start our Ruby server. 
We need to make sure that all of our dirs are readable and writeable, so we move them into our root bin dir. This way we don't have two bins to manage. It keeps our actions we will be able to perform nice and neat. 
Now we can apply our perms in the console for our CRUD to make them all executable.
```sh
chmod u+x bin/terratowns/*
```