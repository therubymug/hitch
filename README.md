hitch
=====
by Rogelio J. Samour (http://blog.therubymug.com)

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
* rvm users run this:
<pre><code>for x in $(rvm list strings); do rvm use $x@global && gem install hitch; done</code></pre>
* hitch --setup >> ~/.bashrc
  - this prints out the necessary shell function and aliases you need to add to your ~/.bashrc or ~/.zshrc
* Or copy/paste the following into your ~/.bashrc or ~/.zshrc:
<pre><code>hitch() {
  command hitch "$@"
  if [[ -s "$HOME/.hitch_export_authors" ]] ; then source "$HOME/.hitch_export_authors" ; fi
}
alias unhitch='hitch -u'
# Uncomment to persist pair info between terminal instances
# hitch
</code></pre>

Alternatively, copy/symlink the script somewhere (e.g. `~/.bash/hitch.sh`, `/etc/profile.d/hitch.sh`). You can get the path using:

    hitch --setup-path

Scripts in `/etc/profile.d/` should be loaded automatically, but if not, use `source path/to/file`.

Development:
-----------

* It's easier if you use rvm.
* Fork hitch
* When you cd into the directory the .rvmrc will activate and create a hitch gemset
* Then run the following scripts:
<pre><code>sh install_supported_rubies.sh
sh rake_spec_with_all_rubies.sh # this also bundles all necessary gems</code></pre>

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
