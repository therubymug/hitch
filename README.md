hitch
=====
by Rogelio J. Samour (http://blog.therubymug.com)

[![Build Status](https://travis-ci.org/therubymug/hitch.png?branch=master)](https://travis-ci.org/therubymug/hitch)

Description:
-----------

Hitch allows developers to be properly credited when Pair Programming and using Git.

Features:
--------

* Persists pair(s) between different terminal instances.
* Creates a unique email address for the pair. (e.g. dev+fry+leela@hashrocket.com) This provides the ability to create a Gravatar for the pair.
* Allows you to expire the pair information in N hours. e.g. hitch --expire 8 fry leela

Synopsis:
--------

- For leela and fry to pair:
  - hitch leela fry
- To clear pair info:
  - hitch -u
- For a complete list of features:
  - hitch -h
- Creating a Gravatar for your pair:
  - Once I've hitched with my pair. (e.g. hitch leela fry) I have now created a unique email: dev+fry+leela@hashrocket.com
  - Then, I go to gravatar.com. Add an image to that particular email address and I'm done.

Install:
-------

* gem install hitch
* chruby users run this:
<pre><code>for x in $(chruby | cut -c 3- | awk '{print $1}'); do chruby $x && gem install hitch; done</code></pre>
* rvm users run this:
<pre><code>for x in $(rvm list strings); do rvm use $x@global && gem install hitch; done</code></pre>
* rbenv users run this:
<pre><code>for x in $(rbenv versions | cut -c 3- | awk '{print $1}'); do rbenv shell $x && gem install hitch; done</code></pre>
* hitch --setup >> ~/.bashrc
  - this prints out the necessary shell function and aliases you need to add to your ~/.bashrc or ~/.zshrc
* Or copy/paste [the code](lib/hitch/hitch.sh) into your ~/.bashrc or ~/.zshrc
* As another option, copy/symlink the script to a separate file (e.g. `~/.bash/hitch.sh` or `/etc/profile.d/hitch.sh`) and source it. You can get the path using `hitch --setup-path`.

Development:
-----------

* It's easier if you use rvm.
* Fork hitch
* When you cd into the directory the .rvmrc will activate and create a hitch gemset
* Add tests and code for your feature
* Create a pull request
* Double-check TravisCI to make sure all tests pass

Requirements:
------------

* Git, HighLine

Acknowledgements:
----------------

* Stephen Caudill
* Les Hill
* Tim Pope

License:
-------
Released under the MIT License.  See the [LICENSE][license] file for further details.

[license]: https://github.com/therubymug/hitch/blob/master/LICENSE.md
