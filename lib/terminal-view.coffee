{View} = require 'space-pen'
TerminalBuffer = require 'terminal/lib/terminal-buffer'
ColorTable = require 'terminal/lib/terminal-color-table'
_ = require 'underscore'
$ = require 'jquery'

module.exports =
class TerminalView extends View
  @content:->
    @div class: "terminal", =>
      @div class: "lines", outlet: "renderedLines"
      @input class: 'hidden-input', outlet: 'hiddenInput'
  @color: (n) ->
    ColorTable[n-16]

  constructor: (session) ->
    super
    @pendingDisplayUpdate = false
    @setModel(session)
    @pendingUpdates = {}
    @session.on 'update', (data) => @queueUpdate(data)
    @session.on 'clear', => @clearView()
    @on 'click', =>
      @hiddenInput.focus()
    @on 'focus', =>
      @hiddenInput.focus()
      # @updateTerminalSize()
      # @scrollToCursor()
      false
    @on 'textInput', (e) =>
      @input(e.originalEvent.data)
      false
    @on 'keydown', (e) =>
      keystroke = keymap.keystrokeStringForEvent(e)
      if match = keystroke.match /^ctrl-([a-zA-Z])$/
        @input(TerminalBuffer.ctrl(match[1]))
        false

    @command "terminal:enter", => @input("#{TerminalBuffer.carriageReturn}")
    @command "terminal:delete", => @input(TerminalBuffer.deleteKey)
    @command "terminal:backspace", => @input(TerminalBuffer.backspace)
    @command "terminal:escape", => @input(TerminalBuffer.escape)
    @command "terminal:tab", => @input(TerminalBuffer.tab)
    for letter in "abcdefghijklmnopqrstuvwxyz"
      do (letter) =>
        key = TerminalBuffer.ctrl(letter)
        @command "terminal:ctrl-#{letter}", => @input(key)
    @command "terminal:paste", => @input(pasteboard.read())
    @command "terminal:left", => @input(TerminalBuffer.escapeSequence("D"))
    @command "terminal:right", => @input(TerminalBuffer.escapeSequence("C"))
    @command "terminal:up", => @input(TerminalBuffer.escapeSequence("A"))
    @command "terminal:down", => @input(TerminalBuffer.escapeSequence("B"))
    @command "terminal:home", => @input(TerminalBuffer.ctrl("a"))
    @command "terminal:end", => @input(TerminalBuffer.ctrl("e"))
    @command "terminal:reload", => @reload()

  setModel: (@session) ->

  input: (data) ->
    @session?.trigger 'input', data

  characterColor: (char, color, bgcolor) ->
    if color >= 16 then char.css(color: "##{TerminalView.color(color)}")
    else if color >= 0 then char.addClass("color-#{color}")
    if bgcolor >= 16 then char.css("background-color": "##{TerminalView.color(bgcolor)}")
    else if bgcolor >= 0 then char.addClass("background-#{bgcolor}")

  renderChar: (c) ->
    char = $("<span>").text(c.char)
    [color, bgcolor] = [c.color, c.backgroundColor]
    if c.reversed
      color = 7 if color == -1
      bgcolor = 7 if bgcolor == -1
      [color, bgcolor] = [bgcolor, color]
    @characterColor(char, color, bgcolor)
    char

  renderLine: (lineNumber, chars) ->
    line = $("<pre>").addClass("line").addClass("line-#{lineNumber}")
    line.append(@renderChar(char)) for char in chars if chars?
    line

  update: ({lineNumber, chars}) ->
    rendered = @renderLine(lineNumber, chars)
    line = @renderedLines.find(".line-#{lineNumber}")
    if line.size() > 0
      $(line.get(0)).replaceWith(rendered)
    else
      @renderedLines.append(rendered)

  queueUpdate: ({lineNumber, chars}) ->
    @pendingUpdates[lineNumber] = chars
    return if @pendingDisplayUpdate
    @pendingDisplayUpdate = true
    _.nextTick =>
      @updateView()
      @pendingDisplayUpdate = false

  updateView: ->
    for lineNumber, chars of @pendingUpdates
      @update({lineNumber: lineNumber, chars: chars})
    @pendingUpdates = {}
    @trigger 'view-updated'

  clearView: ->
    @pendingDisplayUpdate = false
    @pendingUpdates = {}
    @renderedLines.empty()

  buffer: ->
    @session.buffer
