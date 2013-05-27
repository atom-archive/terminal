EventEmitter = require 'event-emitter'
_ = require 'underscore'

module.exports =
class TerminalBuffer
  constructor: ->

_.extend TerminalBuffer.prototype, EventEmitter
