[![Build Status](https://travis-ci.org/jmoody/briar.svg)](https://travis-ci.org/jmoody/briar) [![Dependency Status](https://gemnasium.com/jmoody/briar.svg)](https://gemnasium.com/jmoody/briar)
[![License](https://go-shields.herokuapp.com/license-MIT-blue.png)](http://opensource.org/licenses/MIT)

====

## Briar

Briar extends the [Calabash iOS](https://github.com/calabash/calabash-ios.git)
API to help you write cucumber Scenarios that interact with complex UI elements
like tables, pickers, and sliders.

### Briar is not trying to provide steps that will work for every project.

Every project should cultivate its own [vernacular](http://en.wikipedia.org/wiki/Vernacular) -
a shared language between developers, clients, and users.  The [steps that briar provides](features/step_definitions)
are not meant to be dropped into into your projects.  Briar provides a library
of ruby methods to build application-specific steps from.  The steps in the
features directory are meant to be examples of what briar can offer.

To see briar in action, take a look at https://github.com/jmoody/briar-ios-example

### Motivation

DRY: I have many iOS projects that use Calabash and I found I was rewriting
a lot of supporting code.

## Installation

* Requires ruby >= 2.2.5; the latest release of ruby is recommended.
* Xcode >= 8.0


In your Gemfile:

```
gem "briar", "~> 2.0"

# To use the briar XTC developer tools, include rake
gem "rake", "~> 10.3"
```

In your `features/support/env.rb` file:

```
require "calabash-cucumber/cucumber"
ENV["NO_BRIAR_PREDEFINED_STEPS"] = "1"
require "briar/cucumber"

# Optional
I18n.enforce_available_locales = false
```

To integrate briar and your calabash-ios console see:
https://github.com/jmoody/briar/wiki/Integrating-Briar-Into-Your-Calabash-Console


## briar binary

The briar binary provides useful commands to improve your calabash workflow.

There is detailed help about how to use the .xamarin convention and dotenv to
setup your environment.

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

# install the calabash server from a local repo
$ briar install calabash-server

# do a clean install of your .ipa on named device
$ briar install pluto
$ briar install earp

# open a cucumber html report in your default browser
$ briar report       <== last run against the simulator
$ briar report venus <== last run against venus
```

## Xamarin Test Cloud

Requires adopting the .xamarin convention and a .env file.
See the help for `.xamarin` and `xtc`.

```
# list the currently cached device in ~/.xamarin/test-cloud/ios-sets.csv
$ briar xtc

# submit a job to the iPads device set
$ briar xtc iPads

# submit a job to the iPhones device set with the meal_log profile
$ briar xtc iPhones meal_log
```

## Version Numbers

I will try my best to follow Semantic Versioning [1] when naming the versions.

However, the semantic versioning spec is incompatible with RubyGem's patterns for pre-release gems. [2]

_"But returning to the practical: No release version of SemVer is compatible with Rubygems."_ - David Kellum

- [1] http://semver.org/
- [2] http://gravitext.com/2012/07/22/versioning.html

## Why call it briar?

* http://en.wikipedia.org/wiki/Smoking_pipe_(tobacco)#Calabash
* http://en.wikipedia.org/wiki/Smoking_pipe_(tobacco)#Briar

## Contributing

All pull requests should be based off the `develop` branch.

For more details see the [CONTRIBUTING.md](CONTRIBUTING.md) document.

Please do not change the version number. :)


