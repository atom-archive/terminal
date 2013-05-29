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

  renderRow: (row) ->
    char = $("<span>").text(row)
    char

  renderLine: (lineNumber, rows) ->
    line = $("<pre>").addClass("line").addClass("line-#{lineNumber}")
    line.append(@renderRow(row)) for row in rows
    line

  update: ({lineNumber, rows}) ->
    rendered = @renderLine(lineNumber, rows)
    line = @renderedLines.find(".line-#{lineNumber}")
    if line.size() > 0
      $(line.get(0)).replaceWith(rendered)
    else
      @renderedLines.append(rendered)

  buffer: ->
    @session.buffer
