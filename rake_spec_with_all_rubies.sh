#!/bin/bash

if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
  source "$HOME/.rvm/scripts/rvm"
else
  printf "ERROR: An RVM installation was not found.\n"
fi

rubies=( 1.8.6 1.8.7 1.9.2 )
gemset="hitch"

for x in ${rubies[*]}; do
  rvm use --create $x@$gemset
  if ! command -v bundle >/dev/null; then
    gem install bundler
  fi
  bundle install | grep -v 'Using' | grep -v 'complete' | sed '/^$/d'
  rake spec
done
