{View} = require 'space-pen'
ColorTable = require 'terminal/lib/terminal-color-table'
_ = require 'underscore'
$ = require 'jquery'

module.exports =
class TerminalView extends View
  @content:->
    @div class: "terminal", =>
      @div class: "lines", outlet: "renderedLines"
      @input class: 'hidden-input', outlet: 'hiddenInput'

  constructor: (session) ->
    super
    session.on 'update', (data) => @update(data)
    @setModel(session)

  setModel: (@session) ->

  renderChar: (c) ->
    char = $("<span>").text(c.char)
    char

  renderLine: (lineNumber, chars) ->
    line = $("<pre>").addClass("line").addClass("line-#{lineNumber}")
    line.append(@renderChar(char)) for char in chars
    line

  update: ({lineNumber, chars}) ->
    rendered = @renderLine(lineNumber, chars)
    line = @renderedLines.find(".line-#{lineNumber}")
    if line.size() > 0
      $(line.get(0)).replaceWith(rendered)
    else
      @renderedLines.append(rendered)

  buffer: ->
    @session.buffer
