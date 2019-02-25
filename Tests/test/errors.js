/* eslint-env mocha */

const assert = require('assert')
const addon = require('../')

describe('Errors', () => {
  it('throws an error', () => {
    assert.throws(() => addon.throwError(), (err) => {
      return (err.message === 'Error message' && err.code === 'ETEST')
    })
  })
})
