/* eslint-env mocha */

const addon = require('../')
const assert = require('assert')

describe('Take Values', () => {
  it('takes strings', () => {
    addon.takeString('a string')
  })

  it('takes numbers', () => {
    addon.takeNumber(1337)
  })

  it('takes booleans', () => {
    addon.takeBoolean(true)
  })

  it('takes null', () => {
    addon.takeNull(null)
  })

  it('takes undefined', () => {
    addon.takeUndefined(undefined)
  })

  describe('Errors', () => {
    it('expects strings', () => {
      assert.throws(() => addon.takeString(1337), (err) => err instanceof TypeError && err.message === 'Expected string')
      assert.throws(() => addon.takeString(true), (err) => err instanceof TypeError && err.message === 'Expected string')
      assert.throws(() => addon.takeString(null), (err) => err instanceof TypeError && err.message === 'Expected string')
      assert.throws(() => addon.takeString(undefined), (err) => err instanceof TypeError && err.message === 'Expected string')
      assert.throws(() => addon.takeString(), (err) => err instanceof TypeError && err.message === 'Expected string')
    })

    it('expects numbers', () => {
      assert.throws(() => addon.takeNumber('a string'), (err) => err instanceof TypeError && err.message === 'Expected number')
      assert.throws(() => addon.takeNumber(true), (err) => err instanceof TypeError && err.message === 'Expected number')
      assert.throws(() => addon.takeNumber(null), (err) => err instanceof TypeError && err.message === 'Expected number')
      assert.throws(() => addon.takeNumber(undefined), (err) => err instanceof TypeError && err.message === 'Expected number')
      assert.throws(() => addon.takeNumber(), (err) => err instanceof TypeError && err.message === 'Expected number')
    })

    it('expects booleans', () => {
      assert.throws(() => addon.takeBoolean('a string'), (err) => err instanceof TypeError && err.message === 'Expected boolean')
      assert.throws(() => addon.takeBoolean(1337), (err) => err instanceof TypeError && err.message === 'Expected boolean')
      assert.throws(() => addon.takeBoolean(null), (err) => err instanceof TypeError && err.message === 'Expected boolean')
      assert.throws(() => addon.takeBoolean(undefined), (err) => err instanceof TypeError && err.message === 'Expected boolean')
      assert.throws(() => addon.takeBoolean(), (err) => err instanceof TypeError && err.message === 'Expected boolean')
    })

    it('expects null', () => {
      assert.throws(() => addon.takeNull('a string'), (err) => err instanceof TypeError && err.message === 'Expected null')
      assert.throws(() => addon.takeNull(1337), (err) => err instanceof TypeError && err.message === 'Expected null')
      assert.throws(() => addon.takeNull(true), (err) => err instanceof TypeError && err.message === 'Expected null')
      assert.throws(() => addon.takeNull(undefined), (err) => err instanceof TypeError && err.message === 'Expected null')
      assert.throws(() => addon.takeNull(), (err) => err instanceof TypeError && err.message === 'Expected null')
    })

    it('expects undefined', () => {
      assert.throws(() => addon.takeUndefined('a string'), (err) => err instanceof TypeError && err.message === 'Expected undefined')
      assert.throws(() => addon.takeUndefined(1337), (err) => err instanceof TypeError && err.message === 'Expected undefined')
      assert.throws(() => addon.takeUndefined(true), (err) => err instanceof TypeError && err.message === 'Expected undefined')
      assert.throws(() => addon.takeUndefined(null), (err) => err instanceof TypeError && err.message === 'Expected undefined')
    })
  })
})
