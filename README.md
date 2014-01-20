# Briar

Briar Extends the steps defined in [calabash-ios](https://github.com/calabash/calabash-ios.git) to help you write cucumber Scenarios that interact with complex UI elements like tables, pickers, and sliders.

### WARNING: briar is not trying to provide steps that will work for every project

Every project should cultivate its own [venacular](http://en.wikipedia.org/wiki/Vernacular) - 
a shared language between developers, clients, and users.  The [steps that briar provides](features/step_definitions) are not meant to be dropped into into your projects (although they can be).  Briar provides a library of ruby methods to build application-specific steps from.  The steps in the features directory are meant to be examples of what briar can offer.

To see briar in action, take a look at https://github.com/jmoody/briar-ios-example

### motivation

DRY: I have several iOS projects that use calabash-cucumber and I found I was rewriting lots of steps and supporting code.  

## Installation 

Requires ruby >= 1.8.7; ruby 2.0 is recommended.

In your Gemfile:

```
gem 'briar'
```

In your `features/support/env.rb` file:

```
require 'calabash-cucumber/cucumber'
require 'briar/cucumber'

# optional
I18n.enforce_available_locales = false
```

To integrate briar and your calabash-ios console see: https://github.com/jmoody/briar/wiki/Integrating-Briar-Into-Your-Calabash-Console


## Xamarin Test Cloud

There is currently an issue with using briar predefined steps on the XTC:

```
# fails validation step 
Then I touch the "time" row
```

## version numbers

I will try my best to follow http://semver.org/ when naming the versions.

## Why call it briar? 

* http://en.wikipedia.org/wiki/Smoking_pipe_(tobacco)#Calabash
* http://en.wikipedia.org/wiki/Smoking_pipe_(tobacco)#Briar

## Road Map

I am thinking of dropping all the of predefined steps!  Beware!  You have been warned!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
