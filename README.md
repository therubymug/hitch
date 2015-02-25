Git Pair
=====
by Andre Helberg (@A-Helberg)

[![Build Status](https://travis-ci.org/A-Helberg/git-pair.svg)](https://travis-ci.org/A-Helberg/git-pair)

Description:
-----------

Git Pair allows developers to be jointly credited when Pair Programming and using Git.

Features:
--------

* Persists pair between different terminal instances.
* Can be used in OSX GUI applications ( after restarting the application )
* Allows you to expire the pair information in N hours. e.g. git pair --expire 8 fry leela

Synopsis:
--------

- For leela and fry to pair:
 ```shell
 git pair leela fry
 ```
- To clear pair info:
```shell
git pair unpair
```
- For a complete list of features:
```shell
git pair -h
```

Install:
-------

``` shell
gem install git-pair
```

``` shell
git pair --setup 
```

* this prints out the necessary shell function and aliases you need to add to your ~/.bashrc or ~/.zshrc
  - eg. git pair --setup >> ~/.zshrc
* Or copy/paste [the code](lib/git-pair/git-pair.sh) into your ~/.bashrc or ~/.zshrc
* As another option, copy/symlink the script to a separate file (e.g. `~/.bash/git-pair.sh` or `/etc/profile.d/git-pair.sh`) and source it. You can get the path using `git pair --setup-path`.

Development:
-----------

* Fork git-pair
* Add tests and code for your feature
* Create a pull request
* Double-check TravisCI to make sure all tests pass

Requirements:
------------

* Git, HighLine

Acknowledgements:
----------------

* Rogelio J. Samour (http://blog.therubymug.com)
* Stephen Caudill
* Les Hill
* Tim Pope

License:
-------
Released under the MIT License.  See the [LICENSE][license] file for further details.

[license]: https://github.com/A-Helberg/git-pair/blob/master/LICENSE.md
