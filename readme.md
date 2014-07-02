# Introduction [![Build Status](https://travis-ci.org/lcaballero/CheckThat.svg?branch=master)](https://travis-ci.org/)

This is a little library that is very similar to [Google's Guava checkArgs library][checkArgs].

Though similar, it is not a direct port of that library's interface.  Mostly
due to JavaScript's dynamic nature this library leans towards a more functional
interface.


## Usage

```coffee

CheckThat = require('CheckThat')()

{ exists, notEmpty, checkThat } = CheckThat

importantFunc: (name) ->
    checkThat('Name must exist and be non-empty', name, exists, notEmpty)
    ...
```


## License

See license file.

The use and distribution terms for this software are covered by the
[Eclipse Public License 1.0][EPL-1], which can be found in the file 'license' at the
root of this distribution. By using this software in any fashion, you are
agreeing to be bound by the terms of this license. You must not remove this
notice, or any other, from this software.


[EPL-1]: http://opensource.org/licenses/eclipse-1.0.txt
[checkArgs]: http://docs.guava-libraries.googlecode.com/git/javadoc/com/google/common/base/Preconditions.html
