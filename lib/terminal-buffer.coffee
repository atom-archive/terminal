EventEmitter = require 'event-emitter'
_ = require 'underscore'

module.exports =
class TerminalBuffer
  constructor: ->
    @on 'data', (data) => @output(data)

  output: (data) ->
    console.log data

_.extend TerminalBuffer.prototype, EventEmitter
