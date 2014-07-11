_           = require 'lodash'
{expect}    = require('chai')
CheckThat   = require('../lib/CheckThat')

{ exists, notEmpty, checkConstraints,
  checkThat, checkExists, elseThrowIt,
  elseCallback } = CheckThat

FALSY     = [null, undefined]
WS        = ["\t", "\n", "  "]
THE_GOOD  = ['a', '  b  ', '--']

dump      = (s) ->
  String(s).replace /[\t\r\n]/g, (item) ->
    switch item
      when '\t' then '\\t'
      when '\r' then '\\r'
      when '\n' then '\\n'
      else item



describe "CheckThatTest =>", ->

  describe 'dump', ->
    it 'escape tab, cr, nl', ->
      expect(dump('ab\tcd')).to.equal('ab\\tcd')
      expect(dump('ab\rcd')).to.equal('ab\\rcd')
      expect(dump('ab\ncd')).to.equal('ab\\ncd')


  describe 'checkConstraints =>', ->

    describe 'basic check =>', ->

      good = 'someValue'
      bad  = null

      it "#{good} should fail to exist", ->
        expect(checkConstraints(good, exists), good).to.be.true

      it "#{bad} should fail to exist", ->
        expect(checkConstraints(bad, exists), bad).to.be.false

      it "passing function causes check that to return true", ->
        trueFn = () -> true
        expect(checkConstraints(good, trueFn, trueFn), bad).to.be.true

      it "passing function causes check that to return true", ->
        falseFn = () -> true
        expect(checkConstraints(good, falseFn, falseFn), bad).to.be.true

    describe 'check exists with FALSY values =>', ->
        for v in FALSY
          ((val) -> it "#{dump(val)} should fail to exist", ->
            expect(checkConstraints(val, exists), "#{val}").to.be.false)(v)

    describe 'check exists with GOOD values =>', ->
      good = THE_GOOD.concat([0, false])
      for v in good
        ((val) -> it "'#{dump(val)}' should exist", ->
          expect(checkConstraints(val, exists), "#{val}").to.be.true)(v)

    describe 'check notEmpty with WS', ->
      for v in WS
        ((val) -> it "'#{dump(val)}' should fail to be notEmpty", ->
          expect(checkConstraints(val, notEmpty), "#{val}").to.be.false)(v)

    describe 'check notEmpty with GOOD', ->
      for v in THE_GOOD
        ((val) -> it "'#{dump(val)}' should pass as notEmpty", ->
          expect(checkConstraints(val, notEmpty), "#{val}").to.be.true)(v)


  describe 'checkThat =>', ->

    describe 'check FALSY =>', ->
      for v in FALSY
        ((val) -> it "'#{dump(val)}' falsy value should throw exception", ->
          expect(-> checkThat("FALSY", val, exists)).to.throw("FALSY"))(v)

    describe 'check WS =>', ->
      for v in WS
        ((val) -> it "'#{dump(val)}' ws should throw exception", ->
          expect(-> checkThat("FALSY", val, exists, notEmpty, elseThrowIt)).to.throw("FALSY"))(v)

    describe 'check GOOD =>', ->
      for v in THE_GOOD
        ((val) -> it "'#{dump(val)}' should not throw exception", ->
          expect(checkThat("THE_GOOD", val, exists, notEmpty, elseThrowIt)).to.be.true)(v)

    describe 'check isFunction =>', ->
      for v in [_.isString, _.identity]
        ((val) -> it 'should recognize values as functions', ->
          expect(checkThat('Is function', val, _.isFunction)).to.be.true)(v)

    describe 'check isString =>', ->
      for v in WS
        ((val) -> it "#{dump(val)} values as a string", ->
          expect(checkThat('Is String', val, _.isString)))(v)


  describe 'checkExists =>', ->

    describe 'check FALSY =>', ->
      for v in FALSY
        ((val) -> it "'#{dump(val)}' falsy value should throw exception", ->
          expect(do -> -> checkExists(val, "FALSY")).to.throw("FALSY"))(v)

    describe 'check WS =>', ->
      for v in WS
        ((val) -> it "'#{dump(val)}' ws should throw exception", ->
          expect(checkExists(val, "FALSY")).to.be.true)(v)

