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
module.exports = do ->

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

  resolve = (message, val, predicates...) ->
    if predicates.length <= 0
      throw new Error("Cannot check value without any constraints");
    else if predicates.length is 1
      throwIt(message, checkConstraints(val, predicates...))
    else
      cb = predicates.pop()
      if checkConstraints(val, predicates...)
        cb(null, val)
      else
        cb(new Error(message), val)

  checkThat = (message, val, predicates...) ->
    resolve(message, val, predicates...)

  checkExists = (val, message) ->
    message ?= 'Value must exist (that is not falsy)'
    resolve(message, val, exists, elseThrowIt)

  checkIndex = (arr, index, message) ->
    message ?= "The index #{index} is out of bounds"
    resolve(message, arr, inBounds(arr, index), elseThrowIt)

  checkNonEmpty = (str, message) ->
    message ?= "String must be non-empty, and contain a value once trimmed"
    resolve(message, str, nonEmpty, elseThrowIt)

  hasKeys = (obj, keys, message) ->
    message ?= "The object should contain the keys specified"
    resolve(message, checkConstraints(), elseThrowIt)

  ###
    Helper function which throws an Error with the message provided
    if the second argument @passes is false.
  ###
  throwIt = (message, passes) ->
    if passes
      true
    else
      throw new Error(message)

  elseThrowIt = (err) ->
    if err?
      throw err
    else
      true

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
    elseThrowIt       : elseThrowIt
  }
