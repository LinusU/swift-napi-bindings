/* eslint-env mocha */

const assert = require('assert')
const addon = require('../')

describe('Return Values', () => {
  it('returns strings', () => {
    assert.strictEqual(addon.returnString(), 'a string')
  })

  it('returns numbers', () => {
    assert.strictEqual(addon.returnNumber(), 1337)
  })

  it('returns bolleans', () => {
    assert.strictEqual(addon.returnBoolean(), true)
  })

  it('returns null', () => {
    assert.strictEqual(addon.returnNull(), null)
  })

  it('returns undefined', () => {
    assert.strictEqual(addon.returnUndefined(), undefined)
  })
})
