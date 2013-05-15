{View} = require 'space-pen'

module.exports =
class TerminalView extends View
  @content:->
    @div "Terminal View"

  constructor: (session) ->
    super
    @setModel(session)

  setModel: (@session) ->
