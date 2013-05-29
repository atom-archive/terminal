EventEmitter = require 'event-emitter'
_ = require 'underscore'

module.exports =
class TerminalBuffer
  constructor: ->
    @on 'data', (data) => @output(data)
    @data = ""

  output: (data) ->
    @data += data
    @trigger 'update', {lineNumber:1, rows:@data.split("")}

_.extend TerminalBuffer.prototype, EventEmitter
