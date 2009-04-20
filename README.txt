= hitch
    by Rogelio J. Samour
    http://therubymug.com

== DESCRIPTION:

Hitch allows developers to be properly credited when Pair Programming and using Git.

== FEATURES/PROBLEMS:

* Persists pair(s) between different terminal instances.
* Creates a unique email address for the pair. (e.g. dev+leshill+therubymug@hashrocket.com) This provides the ability to create a Gravatar for the pair.

== SYNOPSIS:

- First, create your hitchrc by running:
  - hitchrc
- To pair with leshill:
  - hitch leshill
- To see a list of available pairs:
  - hitch -i
- To clear pair info:
  - unhitch
- Creating a Gravatar for your pair:
  - Once I've hitched with my pair. (e.g. hitch leshill) I have now created a unique email: dev+leshill+therubymug@hashrocket.com
  - Then, I go to gravatar.com. Add an image to that particular email address and I'm done.

== REQUIREMENTS:

* Git, HighLine

== INSTALL:

* sudo gem install therubymug-hitch

== ACKNOWLEDGEMENTS:

* Les Hill - Refactoring.
* Tim Pope - Original idea.

== LICENSE:

(The MIT License)

Copyright (c) 2009 Rogelio J. Samour

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
