# Introduction [![Build Status](https://travis-ci.org/lcaballero/check-that.svg?branch=master)](https://travis-ci.org/)

This is a little library that is very similar to [Google's Guava checkArgs library][checkArgs].

Though similar, it is not a direct port of that library's interface.  Mostly
due to JavaScript's dynamic nature this library leans towards a more functional
interface.


## Installation

```
%> npm install check-that [--save]
```


## Usage

A typical example is shown below.  This example demonstrates checking the value of 'name'.
The value, in this case, must exist and be non-null.  In this case the default 'exists'
function tests that the value is not `undefined` and not `null`.  But, if the value is either
`null` or `undefined` the check will throw an exception with the last function `elseThrowIt`.

```coffee
# In CoffeeScript:

CheckThat = require('CheckThat')

{ exists, notEmpty, checkThat } = CheckThat

importantFunc: (name) ->
    checkThat('Name must exist and be non-empty', name, exists, notEmpty, elseThrowIt)
    ...
```

```javascript
// In JavaScript:

CheckThat = require('CheckThat')

var exists      = CheckThat.exists,
    notEmpty    = CheckThat.notEmpty,
    checkThat   = CheckThat.checkThat;

function importantFunc(name) {
    checkThat('Name must exist and be non-empty', name, exists, notEmpty, elseThrowIt)
    ...
}
```

The `checkThat` signature is `checkThat(message, val, predicates..., cb)`.  Take note that
the `cb` function appears after the var-args `predicate` appears as the second to last
parameter.  This is a bit unusual, and so how it works needs some explanation.  If the list
of predicates is 1 then the `cb` function defaults to `elseThrowIt`.  Which means that if
the `val` fails to pass the lone predicate an `Error` will be thrown, in this special
case.

The code below is an example where an `Error` will be thrown since only one predicate
function is provided.

```coffee
someFunction: (val) ->
    checkThat('Name must exist', val, exists)
```

As an alternative to the function above where `exists` sits as the last predicate there
another function is provided by `check-that` with `checkExists`.

```coffee
someFunction: (val) ->
    checkExists(val, 'Name must exists')
```

`checkExists` is built on top of `checkThat` and the other predicate functions to produce
a somewhat simpler interface for the same result.

## API

##### `checkThat(message, val, predicates..., cb)`
This is the work horse of the library.  The typical use is shown above.  It accepts
a message and a value to run through the predicates, if the number of predicates is
1 then the signature/logic assumes no callback, and checkThat will throw an
Error (instead of running the callback).  In the case where the number of predicates
is greater than 1 the last function is considered the callback, and will be called
and passed an `Error` wrapping the message if the value fails any of the predicates.
Else the error value to the callback will be `null`.


##### `exists(val)`
##### `notEmpty(val)`


##### `checkConstraints(val, predicates)`
Returns true if *all* the predicates validate the value, else it returns false, and
does not throw an Error.

##### `checkExists(value, [message])`
If the value *is not* `null` and *is not* `undefined`.  If the value is
`null` or `undefined` then an `Error` is thrown with the a default message if one is
not provided.

##### `checkIndex(arr, index, [message])`
Given an any object with a length property this function will validate that index
is both non-negative and less then the length.  Else it will throw an `Error` with
the given message or a default message.

##### `checkNonEmpty(aString, [message])`
Given a string this function will test to see if the string, when trimmed, is non-empty.
If the string is made of of only whitespace then an `Error` will be thrown.

##### `elseThrowIt(err)`
In the code above `elseThrowIt` is shown as the last parameter to `checkThat`.  It
acts as a callback where no custom callback is provided.  If any of the predicates
fail to validate the the value (by returning false) then then `checkThat` will
generate an `Error` with a message and pass it to `elseThrowIt`.  In which case
the error will be non-null and `elseThrowIt` will literally throw the error.  However,
if the all predicates validate the function then error will be null when passed
to `elseThrowIt` and it will return `true` without throwing an `Error`.


## License

See license file.

The use and distribution terms for this software are covered by the
[Eclipse Public License 1.0][EPL-1], which can be found in the file 'license' at the
root of this distribution. By using this software in any fashion, you are
agreeing to be bound by the terms of this license. You must not remove this
notice, or any other, from this software.


[EPL-1]: http://opensource.org/licenses/eclipse-1.0.txt
[checkArgs]: http://docs.guava-libraries.googlecode.com/git/javadoc/com/google/common/base/Preconditions.html
