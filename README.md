# Briar

extends the steps defined in [calabash-ios](https://github.com/calabash/calabash-ios.git) to help
your write cucumber Scenarios that interact with complex ui elements like tables, pickers, and sliders.

### WARNING: briar is not trying to provide steps that will work for every project

Every project should cultivate its own [venacular](http://en.wikipedia.org/wiki/Vernacular) - 
a shared language between developers, clients, and users.  the steps that briar provides
are not meant to be dropped into into your projects (although they can be).  briar provides a 
library [lib] of ruby methods to build application-specific steps from.  the steps in the features 
directory are meant to be examples of what briar can offer.

to see briar in action, take a look at https://github.com/jmoody/briar-ios-example

### motivation

DRY: i have several ios projects that use calabash-cucumber and i found i was rewriting lots of steps
and supporting code.  

## version numbers

i will try my best to follow http://semver.org/ when naming the versions.

## Why call it briar? 

* http://en.wikipedia.org/wiki/Smoking_pipe_(tobacco)#Calabash
* http://en.wikipedia.org/wiki/Smoking_pipe_(tobacco)#Briar

## Installation 

getting closer to stability

* there are still major problems with date picking
* can now run tests on lesspainful! woot!
* there are lot's of wait_for_animation calls that should be replaced with wait_for methods
   
## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
