#!/bin/sh
current_dir=`pwd`
cd ~/git/calabash-ios/calabash-cucumber
rake build_server
cd "$current_dir"
briar rm-cal-targets
cp ~/git/calabash-ios/calabash-cucumber/staticlib/calabash.framework.zip ./
rm -rf calabash.framework
unzip calabash.framework.zip
rm -rf calabash.framework.zip
