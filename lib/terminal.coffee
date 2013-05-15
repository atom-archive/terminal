Project = require 'project'
TerminalSession = require './terminal-session'

module.exports =
  activate: ->
    Project.registerOpener(@customOpener)
    rootView.command 'terminal:open', ->
      directory = project.getPath() ? '~'
      rootView.open("terminal://#{directory}")

  deactivate: ->
    Project.unregisterOpener(@customOpener)

  customOpener: (uri) ->
    if match = uri?.match(/^terminal:\/\/(.*)/)
      uri = match[1]
      new TerminalSession(uri)
