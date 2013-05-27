{View} = require 'space-pen'
ColorTable = require 'terminal/lib/terminal-color-table'
_ = require 'underscore'

module.exports =
class TerminalView extends View
  @content:->
    @div class: "terminal", =>
      @div class: "content", outlet: "content", =>
        @pre
      @input class: 'hidden-input', outlet: 'hiddenInput'

  constructor: (session) ->
    super
    @setModel(session)

  setModel: (@session) ->

  buffer: ->
    @session.buffer
