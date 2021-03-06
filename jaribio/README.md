## Purpose

This is a simple Rails application with the goal to produce an intuitive 
and easy to use interface for the creation of test cases, test suites, 
and test plans.

It will be possible for a person to execute tests, but also it will
be possible for unit testing frameworks to publish test results as well.

## Developers
Some instructions on setting up a development environment that works
with the latest code in master.

- rvm get latest
- rvm install ruby-1.9.3
- rvm --default use ruby-1.9.3-p0
- rvm ruby-1.9.3-p0@jaribio --create
- gem update --system
- cd Jaribio/jaribio
- bundle install

bin/* are scripts that ensure the bundle'd version of the executable will
run rather than the latest version (rubygems default modus operandi)

### JavaScript Runtime for Ubuntu

For Rails 3.1, a JavaScript runtime is needed for development on Linux Ubuntu. 
It is not needed for Mac OS X or Windows.

For development on Linux Ubuntu, it’s best to install the Node.js 
server-side JavaScript environment:

sudo apt-get install nodejs

and set it in your $PATH.

If you don’t install Node.js, you’ll need to add this to the Gemfile for each Rails application you build:

gem 'therubyracer'

There is a similar gem for jruby.

## Upgrading from 1.0

- cd Jaribio/jaribio
- bundle install
- rails runner InitializeSuiteCaseOrder.run
