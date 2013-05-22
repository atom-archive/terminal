{View} = require 'space-pen'
ColorTable = require 'terminal/lib/terminal-color-table'
_ = require 'underscore'

module.exports =
class TerminalView extends View
  @content:->
    @div "Terminal View"

  constructor: (session) ->
    super
    @setModel(session)

  setModel: (@session) ->
