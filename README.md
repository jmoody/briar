[![Dependency Status](https://gemnasium.com/jmoody/briar.svg)](https://gemnasium.com/jmoody/briar)
[![License](https://go-shields.herokuapp.com/license-MIT-blue.png)](http://opensource.org/licenses/MIT)

====

## Briar

Briar Extends the steps defined in [calabash-ios](https://github.com/calabash/calabash-ios.git) to help you write cucumber Scenarios that interact with complex UI elements like tables, pickers, and sliders.

### Briar is not trying to provide steps that will work for every project.

Every project should cultivate its own [vernacular](http://en.wikipedia.org/wiki/Vernacular) - 
a shared language between developers, clients, and users.  The [steps that briar provides](features/step_definitions) are not meant to be dropped into into your projects (although they can be).  Briar provides a library of ruby methods to build application-specific steps from.  The steps in the features directory are meant to be examples of what briar can offer.

To see briar in action, take a look at https://github.com/jmoody/briar-ios-example

### motivation

DRY: I have several iOS projects that use calabash-cucumber and I found I was rewriting lots of supporting code.

## Installation 

Requires ruby >= 1.9.3; ruby 2.1.2 is recommended.

In your Gemfile:

```
gem 'briar', '~>1.1'
```

In your `features/support/env.rb` file:

```
require 'calabash-cucumber/cucumber'
require 'briar/cucumber'

# optional
I18n.enforce_available_locales = false
```

To integrate briar and your calabash-ios console see: https://github.com/jmoody/briar/wiki/Integrating-Briar-Into-Your-Calabash-Console

**WARNING:** I will be dropping the automatic import of pre-defined steps in briar 1.2.0.  The predefined steps will be removed completely in briar 2.0.

## briar binary

The briar binary provides useful commands to improve your calabash workflow.

There is detailed help about how to use the .xamarin convention and dotenv to setup your environment.

```
# help
$ briar help
$ briar help console
$ briar help .xamarin

# open a console against simulators
$ briar console sim6            <== against the current simulator
$ briar console sim7 ipad_r_64  <== changes the default simulator

# open a console against named devices
$ briar console venus
$ briar console neptune

# install the calabash server from a local repo and remove all stale simulator targets in one command
$ briar install calabash-server

# do a clean install of your .ipa on named device
$ briar install pluto
$ briar install earp

# open a cucumber html report in your default browser
$ briar report       <== last run against the simulator
$ briar report venus <== last run against venus

# remove all *-cal targets from the simulator (without resetting the device)
$ briar rm sim-targets

# resolve APP_BUNDLE_PATH auto-detection problems by removing spurious DerivedData directories
$ briar rm dups 
$ briar rm dups briar-ios-example 

# change the simulator version
$ briar sim ipad_r
$ briar sim iphone_4in
```

## Xamarin Test Cloud

There is currently an issue with using briar predefined steps on the XTC:

```
# fails validation step 
Then I touch the "time" row
```

## version numbers

I will try my best to follow Semantic Versioning [1] when naming the versions.

However, the semantic versioning spec is incompatible with RubyGem's patterns for pre-release gems. [2]

_"But returning to the practical: No release version of SemVer is compatible with Rubygems."_ - David Kellum

- [1] http://semver.org/
- [2] http://gravitext.com/2012/07/22/versioning.html


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
