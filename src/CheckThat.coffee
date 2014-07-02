_ = require 'lodash'

###
  This is a little library that is very similar to Google's Guava checkArgs library
  (http://docs.guava-libraries.googlecode.com/git/javadoc/com/google/common/base/Preconditions.html).

  Though similar it is not a direct port of that library's interface.  Mostly
  due to JavaScript's dynamic nature this library leans towards a more functional
  interface.

  Example:

  importantFunc: (name) ->
    checkThat('Name must exist and be non-empty', name, exists, nonEmpty)
    ...

###
module.exports = ->

  ###
     Predicates that can be used with checks and constraints.
  ###
  exists      = (val) -> _.isNumber(val) or _.isBoolean(val) or !!val
  empty       = (val) -> _.isString(val) && val.trim() is ''
  notEmpty    = (val) -> not empty(val)
  inBounds    = (index) -> (arr) -> 0 <= index && index < arr.length
  hasKeys     = (keys) -> (obj) -> _.all(keys, (k) -> _.has(obj, k))

  ###
    Check and constraint functions that test the values provided and
    throw an exception if the value does not pass any predicates
    provided.
  ###
  checkConstraints  = (val, predicates...) ->
    _.all(predicates, (predicate) -> predicate(val))

  checkThat = (message, val, predicates...) ->
    throwIt(message, checkConstraints(val, predicates...))

  checkExists = (val, message) ->
    message ?= 'Value must exist (that is not falsy)'
    throwIt(message, checkConstraints(val, exists))

  checkIndex = (arr, index, message) ->
    message ?= "The index #{index} is out of bounds"
    throwIt(message, checkConstraings(arr, inBounds(arr, index)))

  checkNonEmpty = (str, message) ->
    message ?= "String must be non-empty, and contain a value once trimmed"
    throwIt(message, checkConstraints(str, nonEmpty))

  hasKeys = (obj, keys, message) ->
    message ?= "The object should contain the keys specified"
    throwIt(message, checkConstraints())

  ###
    Helper function which throws an Error with the message provided
    if the second argument @passes is false.
  ###
  throwIt = (message, passes) ->
    if passes
      true
    else
      throw new Error(message)

  return {
    exists            : exists
    empty             : empty
    notEmpty          : notEmpty
    checkThat         : checkThat
    checkConstraints  : checkConstraints
    checkExists       : checkExists

    # TODO: write tests for these checks
    checkIndex        : checkIndex
    checkNonEmpty     : checkNonEmpty
  }
