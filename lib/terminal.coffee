Project = require 'project'
TerminalSession = require './terminal-session'

nextTerminalId = 1

module.exports =
  activate: ->
    Project.registerOpener(@customOpener)
    rootView.command 'terminal:open', ->
      directory = project.getPath() ? '~/'
      rootView.open("terminal://#{nextTerminalId++}/#{directory}")

  deactivate: ->
    Project.unregisterOpener(@customOpener)

  customOpener: (uri) ->
    if match = uri?.match(/^terminal:\/\/(\d*)\/(.*)/)
      uri = match[2]
      new TerminalSession(uri)
