#!/bin/bash

rubies=( 1.8.6 1.8.7 1.9.2 )
gemset="hitch"

for x in ${rubies[*]}; do rvm use --create $x@$gemset && bundle install; done
for x in ${rubies[*]}; do rvm use $x@$gemset && rake; done
