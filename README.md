Pair Up [![Build Status](https://travis-ci.org/A-Helberg/pair-up.svg)](https://travis-ci.org/A-Helberg/pair-up)
=====

by Andre Helberg ([@A_Helberg](http://twitter.com/a_helberg))

Description:
-----------

Pair Up allows two developers to be jointly credited when Pair Programming and using Git.

Features:
--------

* Persists pair between different terminal instances.
* Can be used in OSX GUI applications ( after restarting the application )
* Allows you to expire the pair information in N hours. e.g. pair --expire 8 fry leela

Why use Pair Up instead of other tools?:
---------------------------------------

Pair Up is based off the solid work of [Hitch](https://github.com/therubymug/hitch). Its main differentiating factor is that it picks one developer to be the author, and another to be the committer. Similar solutions create a dummy email account of all devs, which could potentially be more than two. Pair Up only allows two devs. One will be the author (usually the person that is driving) and the other is the committer. No extra email accounts or gravatar setups are required.

Installation & Usage:
----------
Install the gem and add the setup to the end of your zshrc or bashrc file
```shell
$ gem install pair-up 
```

```shell
$ pair --setup >> ~/.zshrc
```

Restart your terminal.

To pair with someone replace the following names with your github names
```shell
$ pair A-Helberg aleciafb
```

Now just commit as you usually would. If you use a gui application on OSX, remember to restart it when you setup a new pair or switch pairs for it to take effect. The first username will be used as the author and the second username as the committer.

 To switch the pairs around run:
``` shell
$ pair --switch
```

Don't forget to unpair when you are done:
``` shell
$ pair -u
```

For some help and a complete list of features:
```shell
$ pair -h
```

Install:
-------

``` shell
gem install pair-up
```

``` shell
pair --setup 
```

* this prints out the necessary shell function and aliases you need to add to your ~/.bashrc or ~/.zshrc
  - eg. `pair --setup >> ~/.zshrc`
* Or copy/paste [the code](lib/pair-up/pair-up.sh) into your ~/.bashrc or ~/.zshrc
* As another option, copy/symlink the script to a separate file (e.g. `~/.bash/pair-up.sh` or `/etc/profile.d/pair-up.sh`) and source it. You can get the path using `pair --setup-path`.
* Restart your terminal.

Development:
-----------

* Fork pair-up
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

[license]: https://github.com/A-Helberg/pair-up/blob/master/LICENSE.md
